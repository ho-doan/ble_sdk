import 'package:ble_sdk/ble_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  final ctlServices = TextEditingController();
  List<BluetoothBLEModel> devices = [];
  BluetoothBLEModel? deviceCurrent;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            /// scan
            CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text('Ble Sdk'),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'servicesUUID ex: 1808,1810',
                          ),
                          style: const TextStyle(fontSize: 12),
                          controller: ctlServices,
                        ),
                      ),
                      GestureDetector(
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
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          color: Colors.blue,
                          child: const Text(
                            'Close',
                          ),
                        ),
                      ),
                      for (final device in devices)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          child: Text('${device.name}(${device.id})'),
                        )
                    ],
                  ),
                )
              ],
            ),

            /// detail device
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text(
                    'Device ${deviceCurrent?.name}(${deviceCurrent?.id}) -- connected',
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'servicesUUID ex: 1808,1810',
                          ),
                          style: const TextStyle(fontSize: 12),
                          controller: ctlServices,
                        ),
                      ),
                      GestureDetector(
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
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          color: Colors.blue,
                          child: const Text(
                            'Close',
                          ),
                        ),
                      ),
                      for (final device in devices)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 6,
                          ),
                          child: Text('${device.name}(${device.id})'),
                        )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
