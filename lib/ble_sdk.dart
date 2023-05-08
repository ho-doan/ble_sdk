import 'dart:async';

import 'ble_sdk_platform_interface.dart';
import 'src/generated/blesdk.pb.dart';

export 'src/generated/blesdk.pbserver.dart';
part 'src/ble_sdk_custom.dart';

abstract class BleSdkNative {
  Future<void> startScan({
    /// services BLE ex: 1808, FFF0, ....
    List<String> services = const [],
  }) =>
      BleSdkPlatform.instance.startScan(ScanModel(services: services));

  Future<void> stopScan() => BleSdkPlatform.instance.stopScan();

  Future<List<Service>> discoverServices() =>
      BleSdkPlatform.instance.discoverServices();

  Future<bool> connect({required String deviceId}) =>
      BleSdkPlatform.instance.connect(ConnectModel(deviceId: deviceId));

  Future<bool> disconnect() => BleSdkPlatform.instance.disconnect();

  Future<CharacteristicValue> writeCharacteristic(CharacteristicValue value) =>
      BleSdkPlatform.instance.writeCharacteristic(value);

  Future<bool> writeCharacteristicNoResponse(CharacteristicValue value) =>
      BleSdkPlatform.instance.writeCharacteristicNoResponse(value);

  Future<CharacteristicValue> readCharacteristic(
    Characteristic characteristic,
  ) =>
      BleSdkPlatform.instance.readCharacteristic(characteristic);

  Future<bool> setNotification(Characteristic characteristic) =>
      BleSdkPlatform.instance.setNotification(characteristic);
  Future<bool> setIndication(Characteristic characteristic) =>
      BleSdkPlatform.instance.setIndication(characteristic);

  Future<bool> checkBonded() => BleSdkPlatform.instance.checkBonded();

  Future<bool> unBonded(String deviceId) =>
      BleSdkPlatform.instance.unBonded(ConnectModel(deviceId: deviceId));

  Future<bool> isBluetoothAvailable() =>
      BleSdkPlatform.instance.isBluetoothAvailable();

  Stream<BluetoothBLEModel> get deviceResult =>
      BleSdkPlatform.instance.deviceResult();

  Stream<StateConnect> get stateConnectResult =>
      BleSdkPlatform.instance.stateConnectResult();

  Stream<StateBluetooth> get stateBluetoothResult =>
      BleSdkPlatform.instance.stateBluetoothResult();
  Stream<CharacteristicValue> get characteristicResult =>
      BleSdkPlatform.instance.characteristicResult();

  Stream<Log> get logResult => BleSdkPlatform.instance.logResult();
}
