import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ble_sdk_method_channel.dart';
import 'src/generated/blesdk.pb.dart';

abstract class BleSdkPlatform extends PlatformInterface {
  /// Constructs a BleSdkPlatform.
  BleSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static BleSdkPlatform _instance = MethodChannelBleSdk();

  /// The default instance of [BleSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelBleSdk].
  static BleSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BleSdkPlatform] when
  /// they register themselves.
  static set instance(BleSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// start scan ble with [services] default list empty
  /// [services] BLE ex: 1808, FFF0, ....
  Future<void> startScan(ScanModel scanModel) =>
      throw UnimplementedError('startScan() has not been implemented.');

  /// stop scan ble
  Future<void> stopScan() =>
      throw UnimplementedError('stopScan() has not been implemented.');

  /// discoverServices device current connect
  /// return [Services]
  Future<List<Service>> discoverServices() =>
      throw UnimplementedError('discoverServices() has not been implemented.');

  /// connect ble device with [deviceId]
  /// [createBond] using open pin code dialog with read/write characteristic authorize
  Future<bool> connect(ConnectModel connectModel) =>
      throw UnimplementedError('connect() has not been implemented.');

  /// disconnect current ble device
  Future<bool> disconnect() =>
      throw UnimplementedError('disconnect() has not been implemented.');

  /// write characteristic with [value]
  /// return [CharacteristicValue]
  Future<CharacteristicValue> writeCharacteristic(CharacteristicValue value) =>
      throw UnimplementedError(
          'writeCharacteristic() has not been implemented.');

  /// read characteristic with [characteristic]
  /// return [CharacteristicValue]
  Future<bool> writeCharacteristicNoResponse(CharacteristicValue value) =>
      throw UnimplementedError(
          'writeCharacteristicNoResponse() has not been implemented.');

  /// read characteristic with [characteristic]
  /// return [CharacteristicValue]

  Future<CharacteristicValue> readCharacteristic(
          Characteristic characteristic) =>
      throw UnimplementedError(
          'readCharacteristic() has not been implemented.');

  /// set notification with [characteristic] contains notify
  /// return [bool]

  Future<bool> setNotification(Characteristic characteristic) =>
      throw UnimplementedError('setNotification() has not been implemented.');

  /// set indication with [characteristic] contains notify
  /// return [bool]
  Future<bool> setIndication(Characteristic characteristic) =>
      throw UnimplementedError('setIndication() has not been implemented.');

  /// check bonded ble device after connect
  /// return [bool]
  Future<bool> checkBonded() =>
      throw UnimplementedError('checkBonded() has not been implemented.');

  /// un bonded ble device with [deviceId]
  /// TODO: support only android
  Future<bool> unBonded(ConnectModel model) =>
      throw UnimplementedError('unBonded() has not been implemented.');

  /// check permission app
  /// return [PermissionResult]
  Future<PermissionResult> checkPermission() async {
    throw UnimplementedError('checkPermission() has not been implemented.');
  }

  /// request permission return [bool]
  Future<bool> requestPermission() async {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  /// open settings detail app
  Future<void> requestPermissionSettings() async {
    throw UnimplementedError(
        'requestPermissionSettings() has not been implemented.');
  }

  /// turn on bluetooth
  Future<void> turnOnBluetooth() async {
    throw UnimplementedError('turnOnBluetooth() has not been implemented.');
  }

  /// turn on location
  Future<void> turnOnLocation() async {
    throw UnimplementedError('turnOnBluetooth() has not been implemented.');
  }

  /// check bluetooth on/off
  Future<bool> isBluetoothAvailable() => throw UnimplementedError(
      'isBluetoothAvailable() has not been implemented.');

  /// check location on/off
  Future<bool> isLocationAvailable() => throw UnimplementedError(
      'isLocationAvailable() has not been implemented.');

  /// initialSdk
  Future<bool> initialSdk() =>
      throw UnimplementedError('initialSdk() has not been implemented.');

  /// subscription scan [BluetoothBLEModel] device
  Stream<BluetoothBLEModel> deviceResult() =>
      throw UnimplementedError('deviceResult() has not been implemented.');

  /// subscription log characteristic result with read/write/notification/indication
  /// return [Log]
  Stream<Log> logResult() =>
      throw UnimplementedError('logResult() has not been implemented.');

  /// subscription connection [StateConnect] device
  Stream<StateConnect> stateConnectResult() => throw UnimplementedError(
      'stateConnectResult() has not been implemented.');

  /// subscription on/off [StateBluetooth] bluetooth
  Stream<StateBluetooth> stateBluetoothResult() => throw UnimplementedError(
      'stateBluetoothResult() has not been implemented.');

  /// subscription characteristic result with read/write
  /// return [CharacteristicValue]
  Stream<CharacteristicValue> characteristicResult() =>
      throw UnimplementedError(
          'stateBluetoothResult() has not been implemented.');
}
