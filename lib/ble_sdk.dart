import 'ble_sdk_platform_interface.dart';
import 'src/generated/blesdk.pb.dart';

export 'src/generated/blesdk.pbserver.dart';

class BleSdk {
  const BleSdk._();
  static const instance = BleSdk._();
  Future<void> startScan({
    /// services BLE ex: 1808, FFF0, ....
    List<String> services = const [],
  }) =>
      BleSdkPlatform.instance.startScan(services);
  Future<void> stopScan() => BleSdkPlatform.instance.stopScan();
  Future<List<Service>> discoverServices() =>
      BleSdkPlatform.instance.discoverServices();
  Future<bool> connect({required String deviceId}) =>
      BleSdkPlatform.instance.connect(deviceId);
  Future<void> disconnect() => BleSdkPlatform.instance.disconnect();
  Future<CharacteristicValue> writeCharacteristic(CharacteristicValue value) =>
      BleSdkPlatform.instance.writeCharacteristic();
  Future<CharacteristicValue> readCharacteristic({
    required Characteristic characteristic,
  }) =>
      BleSdkPlatform.instance.readCharacteristic(characteristic);
  Future<void> setNotification({
    required Characteristic characteristic,
  }) =>
      BleSdkPlatform.instance.setNotification(characteristic);
  Future<void> checkBonded() => BleSdkPlatform.instance.checkBonded();
  Future<void> unBonded() => BleSdkPlatform.instance.unBonded();
  Future<void> isBluetoothAvailable() =>
      BleSdkPlatform.instance.isBluetoothAvailable();
  Stream<BluetoothBLEModel> get deviceResult =>
      BleSdkPlatform.instance.deviceResult();
  Stream<Log> get logResult => BleSdkPlatform.instance.logResult();
}
