import 'dart:async';

import 'package:ble_sdk/ble_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ScanPage()));
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late StreamSubscription deviceStream;

  bool isScan = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (isScan) {
      deviceStream.cancel();
    }
    super.dispose();
  }

  final ctlServices = TextEditingController();
  List<BluetoothBLEModel> devices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Ble Sdk'),
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'servicesUUID ex: 1808,1810',
                    ),
                    validator: (s) =>
                        s == null || !s.split(',').any((e) => e.length != 4)
                            ? null
                            : 'server is not validator',
                    autovalidateMode: AutovalidateMode.always,
                    style: const TextStyle(fontSize: 12),
                    controller: ctlServices,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!ctlServices.text
                        .split(',')
                        .any((e) => e.length != 4)) {
                      setState(() => isScan = true);
                      BleSdk.instance.startScan(
                        services: ctlServices.text
                            .split(',')
                            .where((s) => s.length == 4)
                            .toList(),
                      );
                      setState(() => devices = []);
                      deviceStream =
                          BleSdk.instance.deviceResult.listen((event) {
                        setState(
                          () => devices = List.from(devices)..add(event),
                        );
                      });

                      /// TODO: hodoan -> fake data
                      setState(
                        () => devices = [
                          BluetoothBLEModel(
                            id: '000000000',
                            name: 'model fake 01',
                            bonded: false,
                          ),
                        ],
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 6,
                    ),
                    color: Colors.blue,
                    child: const Text(
                      'Scan',
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                GestureDetector(
                  onTap: () {
                    BleSdk.instance.stopScan();
                    if (isScan) {
                      deviceStream.cancel();
                      setState(() => isScan = false);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 6,
                    ),
                    color: Colors.blue,
                    child: const Text(
                      'Stop',
                    ),
                  ),
                ),
                const SizedBox(width: 2),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                for (final device in devices)
                  Container(
                    color: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('${device.name}(${device.id})'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // bool isConnect = await BleSdk.instance
                            //     .connect(deviceId: device.id);
                            if (true) {
                              //isConnect
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => DevicePage(device: device),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            color: Colors.blue,
                            child: const Text(
                              'Connect',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DevicePage extends StatefulWidget {
  const DevicePage({
    super.key,
    required this.device,
  });
  final BluetoothBLEModel device;

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  List<Service> _services = [];
  List<String> _logs = [
    ///TODO: fake data
    '000000 - log fake',
  ];
  late StreamSubscription logStream;
  @override
  void initState() {
    logStream = BleSdk.instance.logResult.listen((event) {
      setState(() => _logs = List.from(_logs)
        ..add('${event.characteristic.characteristicId}: ${event.message}'));
    });
    super.initState();
  }

  @override
  void dispose() {
    logStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Device ${widget.device.name}\n(${widget.device.id}) -- connected',
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final services = await BleSdk.instance.discoverServices();
                  setState(
                    () => _services = [
                      ...services,

                      ///TODO: hodoan -> fake data
                      Service(
                        serviceId: '0000000',
                        characteristics: [
                          Characteristic(
                            characteristicId: '000000',
                            properties: 'read',
                          ),
                        ],
                      )
                    ],
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  color: Colors.blue,
                  child: const Text(
                    'Discover Services',
                  ),
                ),
              ),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: () {
                  BleSdk.instance.disconnect();
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  color: Colors.blue,
                  child: const Text(
                    'Disconnect',
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (ctx) => Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final log in _logs) Text(log),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  color: Colors.blue,
                  child: const Text(
                    'Log',
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              for (final service in _services)
                Container(
                  color: Colors.grey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Text('service: ${service.serviceId}'),
                      ),
                      for (final char in service.characteristics)
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'characteristic: ${char.characteristicId}(${char.properties})',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  final ctlValue = TextEditingController();
                                  showDialog(
                                    context: context,
                                    builder: (context) => Material(
                                      type: MaterialType.transparency,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: ctlValue,
                                            ),
                                            GestureDetector(
                                              onTap: () => BleSdk.instance
                                                  .writeCharacteristic(
                                                CharacteristicValue(
                                                  characteristic: char,
                                                  data: ctlValue.text
                                                      .split(',')
                                                      .map(
                                                        (e) => int.parse(e),
                                                      ),
                                                ),
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 4,
                                                  horizontal: 6,
                                                ),
                                                color: Colors.blue,
                                                child: const Text(
                                                  'write',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  color: Colors.blue,
                                  child: const Text(
                                    'write',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              GestureDetector(
                                onTap: () => BleSdk.instance.readCharacteristic(
                                  characteristic: char,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  color: Colors.blue,
                                  child: const Text(
                                    'read',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 2),
                              GestureDetector(
                                onTap: () => BleSdk.instance
                                    .setNotification(characteristic: char),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  color: Colors.blue,
                                  child: const Text(
                                    'notify',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
