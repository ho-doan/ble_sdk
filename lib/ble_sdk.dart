import 'dart:async';

import 'ble_sdk_platform_interface.dart';
import 'src/generated/blesdk.pb.dart';

export 'src/generated/blesdk.pbserver.dart';
part 'src/ble_sdk_custom.dart';

abstract class BleSdkNative {
  /// start scan ble with [services] default list empty
  Future<void> startScan({
    /// services BLE ex: 1808, FFF0, ....
    List<String> services = const [],
  }) =>
      BleSdkPlatform.instance.startScan(ScanModel(services: services));

  /// stop scan ble
  Future<void> stopScan() => BleSdkPlatform.instance.stopScan();

  /// discoverServices device current connect
  /// return [Services]
  Future<List<Service>> discoverServices() =>
      BleSdkPlatform.instance.discoverServices();

  /// connect ble device with [deviceId]
  /// [createBond] using open pin code dialog with read/write characteristic authorize
  Future<bool> connect({
    required String deviceId,
    bool createBond = false,
  }) =>
      BleSdkPlatform.instance.connect(
        ConnectModel(
          deviceId: deviceId,
          createBonded: createBond,
        ),
      );

  /// disconnect current ble device
  Future<bool> disconnect() => BleSdkPlatform.instance.disconnect();

  /// write characteristic with [value]
  /// return [CharacteristicValue]
  Future<CharacteristicValue> writeCharacteristic(CharacteristicValue value) =>
      BleSdkPlatform.instance.writeCharacteristic(value);

  /// using write characteristic notify return value | [characteristicResult] listen value
  /// write characteristic with [value]
  /// return [bool]
  Future<bool> writeCharacteristicNoResponse(CharacteristicValue value) =>
      BleSdkPlatform.instance.writeCharacteristicNoResponse(value);

  /// read characteristic with [characteristic]
  /// return [CharacteristicValue]
  Future<CharacteristicValue> readCharacteristic(
    Characteristic characteristic,
  ) =>
      BleSdkPlatform.instance.readCharacteristic(characteristic);

  /// set notification with [characteristic] contains notify
  /// return [bool]
  Future<bool> setNotification(Characteristic characteristic) =>
      BleSdkPlatform.instance.setNotification(characteristic);

  /// set indication with [characteristic] contains notify
  /// return [bool]
  Future<bool> setIndication(Characteristic characteristic) =>
      BleSdkPlatform.instance.setIndication(characteristic);

  /// check bonded ble device after connect
  /// return [bool]
  Future<bool> checkBonded() => BleSdkPlatform.instance.checkBonded();

  /// un bonded ble device with [deviceId]
  Future<bool> unBonded(String deviceId) =>
      BleSdkPlatform.instance.unBonded(ConnectModel(deviceId: deviceId));

  /// check bluetooth on/off
  Future<bool> isBluetoothAvailable() =>
      BleSdkPlatform.instance.isBluetoothAvailable();

  /// check permission app
  /// return [PermissionResult]
  Future<PermissionResult> checkPermission() =>
      BleSdkPlatform.instance.checkPermission();

  /// request permission return [bool]
  Future<bool> requestPermission() =>
      BleSdkPlatform.instance.requestPermission();

  /// turn on bluetooth
  Future<void> turnOnBluetooth() => BleSdkPlatform.instance.turnOnBluetooth();

  /// open settings detail app
  Future<void> requestPermissionSettings() =>
      BleSdkPlatform.instance.requestPermissionSettings();

  /// subscription scan [BluetoothBLEModel] device
  Stream<BluetoothBLEModel> get deviceResult =>
      BleSdkPlatform.instance.deviceResult();

  /// subscription connection [StateConnect] device
  Stream<StateConnect> get stateConnectResult =>
      BleSdkPlatform.instance.stateConnectResult();

  /// subscription on/off [StateBluetooth] bluetooth
  Stream<StateBluetooth> get stateBluetoothResult =>
      BleSdkPlatform.instance.stateBluetoothResult();

  /// subscription characteristic result with read/write
  /// return [CharacteristicValue]
  Stream<CharacteristicValue> get characteristicResult =>
      BleSdkPlatform.instance.characteristicResult();

  /// subscription log characteristic result with read/write/notification/indication
  /// return [Log]
  Stream<Log> get logResult => BleSdkPlatform.instance.logResult();
}
