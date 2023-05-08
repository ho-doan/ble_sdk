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
                            BleSdk.instance
                                .connect(deviceId: device.id)
                                .then((value) {
                              if (value) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        DevicePage(device: device),
                                  ),
                                );
                              }
                            });
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
  List<String> _logs = [];
  late StreamSubscription logStream;
  @override
  void initState() {
    logStream = BleSdk.instance.logResult.listen((event) {
      setState(() => _logs = List.from(_logs)
        ..add(
            '${event.characteristic.characteristicId.replaceAll('0000', '').split('-').first}: ${event.message}'));
    });
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   BleSdk.instance.stateConnectResult.listen((event) {
    //     if (event == StateConnect.DISCONNECTED) {
    //       Navigator.of(context).pop();
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    logStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                      () => _services = services,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 6,
                    ),
                    color: Colors.blue,
                    child: const Text(
                      'Discover',
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                GestureDetector(
                  onTap: () => BleSdk.instance.disconnect().then(
                        (value) => Navigator.of(context).pop(),
                      ),
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
                          child: ListView(
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
                  ServiceWidget(service: service),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({
    super.key,
    required this.service,
  });

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                  'S: ${service.serviceId.replaceFirst('0000', '').split('-').first}'),
            ),
            for (final char in service.characteristics)
              CharacteristicWidget(char: char),
          ],
        ),
      ),
    );
  }
}

class CharacteristicWidget extends StatefulWidget {
  const CharacteristicWidget({
    super.key,
    required this.char,
  });

  final Characteristic char;

  @override
  State<CharacteristicWidget> createState() => _CharacteristicWidgetState();
}

class _CharacteristicWidgetState extends State<CharacteristicWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4).copyWith(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '- C: ${widget.char.characteristicId.replaceAll('0000', '').split('-').first}(${widget.char.properties.map((e) => e.name).join(',')})',
            ),
          ),
          if (widget.char.characteristicId.contains('2a52'))
            GestureDetector(
              onTap: () async {
                await BleSdk.instance.setNotification(
                  Characteristic(
                    characteristicId: widget.char.characteristicId
                        .replaceFirst('2a52', '2a28'),
                    serviceId:
                        widget.char.serviceId.replaceFirst('1808', '180a'),
                  ),
                );
                await BleSdk.instance.setNotification(
                  Characteristic(
                    characteristicId: widget.char.characteristicId
                        .replaceFirst('2a52', '2a25'),
                    serviceId:
                        widget.char.serviceId.replaceFirst('1808', '180a'),
                  ),
                );
                await BleSdk.instance.setNotification(widget.char);

                await BleSdk.instance.setNotification(
                  Characteristic(
                    characteristicId: widget.char.characteristicId
                        .replaceFirst('2a52', '2a34'),
                    serviceId: widget.char.serviceId,
                  ),
                );
                // await BleSdk.instance.writeCharacteristic(
                //   CharacteristicValue(
                //     characteristic: widget.char,
                //     data: [4, 1],
                //   ),
                // );
                await BleSdk.instance.writeCharacteristic(
                  CharacteristicValue(
                    characteristic: widget.char,
                    data: [1, 0],
                  ),
                );

                await BleSdk.instance.writeCharacteristic(
                  CharacteristicValue(
                    characteristic: widget.char,
                    data: [1, 1],
                  ),
                );
                // await Future.forEach(
                //   List.generate(8, (index) => index),
                //   (i) async => await Future.delayed(
                //     const Duration(
                //       milliseconds: 150,
                //     ),
                //     () => BleSdk.instance.writeCharacteristic(
                //       CharacteristicValue(
                //         characteristic: widget.char,
                //         characteristicNotify: Characteristic(
                //           characteristicId: widget.char.characteristicId
                //               .replaceFirst('2a52', '2a18'),
                //           serviceId: widget.char.serviceId,
                //         ),
                //         data: [0, 3, 1, i + 1, 0],
                //       ),
                //     ),
                //   ),
                // );
              },
              child: const Icon(
                Icons.download,
                size: 28,
                color: Colors.yellow,
              ),
            ),
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.char.properties
                    .contains(CharacteristicProperties.READ))
                  GestureDetector(
                    onTap: () =>
                        BleSdk.instance.readCharacteristic(widget.char),
                    child: const Icon(
                      Icons.read_more,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                if (widget.char.properties
                    .contains(CharacteristicProperties.WRITE))
                  GestureDetector(
                    onTap: () => _write(widget.char),
                    child: const Icon(
                      Icons.edit_note,
                      size: 28,
                      color: Colors.green,
                    ),
                  ),
                if (widget.char.properties
                    .contains(CharacteristicProperties.NOTIFY))
                  GestureDetector(
                    onTap: () => BleSdk.instance.setNotification(widget.char),
                    child: const Icon(
                      Icons.notifications_on,
                      size: 28,
                      color: Colors.redAccent,
                    ),
                  ),
                if (widget.char.properties
                    .contains(CharacteristicProperties.INDICATE))
                  GestureDetector(
                    onTap: () => BleSdk.instance.setNotification(widget.char),
                    child: const Icon(
                      Icons.drag_indicator_rounded,
                      size: 28,
                      color: Colors.redAccent,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _write(Characteristic char) {
    showDialog(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: WriteCharacteristicWidget(char: widget.char),
        ),
      ),
    );
  }
}

class WriteCharacteristicWidget extends StatefulWidget {
  const WriteCharacteristicWidget({
    super.key,
    required this.char,
  });
  final Characteristic char;

  @override
  State<WriteCharacteristicWidget> createState() =>
      _WriteCharacteristicWidgetState();
}

class _WriteCharacteristicWidgetState extends State<WriteCharacteristicWidget> {
  final ctlValue = TextEditingController(text: '4');
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      padding: const EdgeInsets.all(10),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Write value characteristic: ${widget.char.characteristicId.replaceAll('0000', '').split('-').first}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextFormField(
            controller: ctlValue,
            decoration: const InputDecoration(
              hintText: '0 or 0,1,2,3,4 ...',
              border: OutlineInputBorder(),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => BleSdk.instance.writeCharacteristic(
              CharacteristicValue(
                characteristic: widget.char,
                data: ctlValue.text.split(',').map(
                      (e) => int.parse(e),
                    ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 20,
              ),
              child: const Text(
                'Write',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
