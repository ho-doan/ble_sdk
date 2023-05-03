import 'package:ble_sdk/src/generated/blesdk.pb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ble_sdk_platform_interface.dart';

/// An implementation of [BleSdkPlatform] that uses method channels.
class MethodChannelBleSdk extends BleSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ble_sdk');

  @override
  Future<void> startScan(List<String> services) =>
      methodChannel.invokeMethod<void>('startScan', {
        'services': services,
      });
  @override
  Future<void> stopScan() => methodChannel.invokeMethod<void>('stopScan');
  @override
  Future<List<Service>> discoverServices() => methodChannel
      .invokeMethod<Uint8List>('discoverServices')
      .then((value) => value != null
          ? Services.fromBuffer(value.toList()).services
          : const []);

  @override
  Future<bool> connect(String deviceId) =>
      methodChannel.invokeMethod<bool>('connect', {
        'deviceId': deviceId,
      }).then((value) => value ?? false);

  @override
  Future<bool> disconnect() => methodChannel
      .invokeMethod<bool>('disconnect')
      .then((value) => value ?? false);

  @override
  Future<CharacteristicValue> writeCharacteristic() =>
      methodChannel.invokeMethod<Uint8List>('writeCharacteristic').then(
            (value) => value != null
                ? CharacteristicValue.fromBuffer(value)
                : throw Exception('value null'),
          );

  @override
  Future<CharacteristicValue> readCharacteristic(
          Characteristic characteristic) =>
      methodChannel
          .invokeMethod<Uint8List>(
            'readCharacteristic',
            characteristic.writeToBuffer(),
          )
          .then(
            (value) => value != null
                ? CharacteristicValue.fromBuffer(value)
                : throw Exception('value null'),
          );

  @override
  Future<bool> setNotification(Characteristic characteristic) => methodChannel
      .invokeMethod<bool>('setNotification', characteristic.writeToBuffer())
      .then((value) => value ?? false);

  @override
  Future<bool> checkBonded() => methodChannel
      .invokeMethod<bool>('checkBonded')
      .then((value) => value ?? false);

  @override
  Future<bool> unBonded() => methodChannel
      .invokeMethod<bool>('unBonded')
      .then((value) => value ?? false);

  @override
  Future<bool> isBluetoothAvailable() => methodChannel
      .invokeMethod<bool>('isBluetoothAvailable')
      .then((value) => value ?? false);
  @override
  Stream<BluetoothBLEModel> deviceResult() {
    // TODO: implement deviceResult
    return super.deviceResult();
  }
}
