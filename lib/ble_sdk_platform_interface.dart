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

  Future<void> startScan(ScanModel scanModel) =>
      throw UnimplementedError('startScan() has not been implemented.');

  Future<void> stopScan() =>
      throw UnimplementedError('stopScan() has not been implemented.');

  Future<List<Service>> discoverServices() =>
      throw UnimplementedError('discoverServices() has not been implemented.');

  Future<bool> connect(ConnectModel connectModel) =>
      throw UnimplementedError('connect() has not been implemented.');

  Future<bool> disconnect() =>
      throw UnimplementedError('disconnect() has not been implemented.');

  Future<CharacteristicValue> writeCharacteristic(CharacteristicValue value) =>
      throw UnimplementedError(
          'writeCharacteristic() has not been implemented.');

  Future<bool> writeCharacteristicNoResponse(CharacteristicValue value) =>
      throw UnimplementedError(
          'writeCharacteristicNoResponse() has not been implemented.');

  Future<CharacteristicValue> readCharacteristic(
          Characteristic characteristic) =>
      throw UnimplementedError(
          'readCharacteristic() has not been implemented.');

  Future<bool> setNotification(Characteristic characteristic) =>
      throw UnimplementedError('setNotification() has not been implemented.');
  Future<bool> setIndication(Characteristic characteristic) =>
      throw UnimplementedError('setIndication() has not been implemented.');

  Future<bool> checkBonded() =>
      throw UnimplementedError('checkBonded() has not been implemented.');

  Future<bool> unBonded(ConnectModel model) =>
      throw UnimplementedError('unBonded() has not been implemented.');

  Future<PermissionResult> checkPermission() async {
    throw UnimplementedError('checkPermission() has not been implemented.');
  }

  Future<bool> requestPermission() async {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<void> requestPermissionSettings() async {
    throw UnimplementedError(
        'requestPermissionSettings() has not been implemented.');
  }

  Future<void> turnOnBluetooth() async {
    throw UnimplementedError('turnOnBluetooth() has not been implemented.');
  }

  Future<bool> isBluetoothAvailable() => throw UnimplementedError(
      'isBluetoothAvailable() has not been implemented.');

  Stream<BluetoothBLEModel> deviceResult() =>
      throw UnimplementedError('deviceResult() has not been implemented.');
  Stream<Log> logResult() =>
      throw UnimplementedError('logResult() has not been implemented.');

  Stream<StateConnect> stateConnectResult() => throw UnimplementedError(
      'stateConnectResult() has not been implemented.');

  Stream<StateBluetooth> stateBluetoothResult() => throw UnimplementedError(
      'stateBluetoothResult() has not been implemented.');

  Stream<CharacteristicValue> characteristicResult() =>
      throw UnimplementedError(
          'stateBluetoothResult() has not been implemented.');
}
