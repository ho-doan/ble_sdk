import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ble_sdk_platform_interface.dart';
import 'src/generated/blesdk.pb.dart';

/// An implementation of [BleSdkPlatform] that uses method channels.
class MethodChannelBleSdk extends BleSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ble_sdk');

  static EventChannel deviceChannel = const EventChannel('ble_sdk_scan');
  static EventChannel stateConnectChannel =
      const EventChannel('ble_sdk_connect');
  static EventChannel stateBluetoothChannel =
      const EventChannel('ble_sdk_bluetooth');
  static EventChannel logsChannel = const EventChannel('ble_sdk_logs');
  static EventChannel characteristicChannel =
      const EventChannel('ble_sdk_char');

  @override
  Future<void> startScan(ScanModel scanModel) =>
      methodChannel.invokeMethod<void>('startScan', scanModel.writeToBuffer());
  @override
  Future<void> stopScan() => methodChannel.invokeMethod<void>('stopScan');
  @override
  Future<List<Service>> discoverServices() => methodChannel
      .invokeMethod('discoverServices')
      .then((value) => Services.fromBuffer(value).services);

  @override
  Future<bool> connect(ConnectModel connectModel) async {
    final result = await methodChannel
        .invokeMethod<bool>('connect', connectModel.writeToBuffer())
        .then((value) => value ?? false);
    if (!result) return false;
    if (Platform.isIOS) {
      await discoverServices();
    }
    final bonded = await checkBonded();
    if (!bonded) {
      await disconnect();
    }
    return bonded;
  }

  @override
  Future<bool> disconnect() => methodChannel
      .invokeMethod<bool>('disconnect')
      .then((value) => value ?? false);

  @override
  Future<CharacteristicValue> writeCharacteristic(CharacteristicValue value) =>
      methodChannel
          .invokeMethod('writeCharacteristic', value.writeToBuffer())
          .then((value) => CharacteristicValue.fromBuffer(value));

  @override
  Future<bool> writeCharacteristicNoResponse(CharacteristicValue value) =>
      methodChannel
          .invokeMethod<bool>(
              'writeCharacteristicNoResponse', value.writeToBuffer())
          .then((value) => value ?? false);

  @override
  Future<CharacteristicValue> readCharacteristic(
          Characteristic characteristic) =>
      methodChannel
          .invokeMethod(
            'readCharacteristic',
            characteristic.writeToBuffer(),
          )
          .then((value) => CharacteristicValue.fromBuffer(value));

  @override
  Future<bool> setNotification(Characteristic characteristic) => methodChannel
      .invokeMethod<bool>('setNotification', characteristic.writeToBuffer())
      .then((value) => value ?? false);
  @override
  Future<bool> setIndication(Characteristic characteristic) => methodChannel
      .invokeMethod<bool>('setIndication', characteristic.writeToBuffer())
      .then((value) => value ?? false);
  @override
  Future<bool> checkBonded() => methodChannel
      .invokeMethod<bool>('checkBonded')
      .then((value) => value ?? false);

  @override
  Future<bool> unBonded(ConnectModel model) => methodChannel
      .invokeMethod<bool>('unBonded', model.writeToBuffer())
      .then((value) => value ?? false);

  @override
  Future<bool> isBluetoothAvailable() => methodChannel
      .invokeMethod<bool>('isBluetoothAvailable')
      .then((value) => value ?? false);

  @override
  Future<bool> isLocationAvailable() => methodChannel
      .invokeMethod<bool>('isLocationAvailable')
      .then((value) => value ?? false);

  @override
  Future<bool> initialSdk() => methodChannel
      .invokeMethod<bool>('initialSdk')
      .then((value) => value ?? false);

  @override
  Future<PermissionResult> checkPermission() => methodChannel
      .invokeMethod<int>('checkPermission')
      .then((value) => value != null
          ? PermissionResult.values[value]
          : PermissionResult.notGranted);

  @override
  Future<bool> requestPermission() => methodChannel
      .invokeMethod<bool>('requestPermission')
      .then((value) => value ?? false);

  @override
  Future<void> requestPermissionSettings() =>
      methodChannel.invokeMethod<void>('requestPermissionSettings');

  @override
  Future<void> turnOnBluetooth() =>
      methodChannel.invokeMethod<void>('turnOnBluetooth');

  @override
  Future<void> turnOnLocation() =>
      methodChannel.invokeMethod<void>('turnOnLocation');

  @override
  Stream<BluetoothBLEModel> deviceResult() => deviceChannel
      .receiveBroadcastStream()
      .map((event) => BluetoothBLEModel.fromBuffer(event));
  @override
  Stream<StateBluetooth> stateBluetoothResult() => stateBluetoothChannel
      .receiveBroadcastStream()
      .map((event) => StateBluetooth.values[event]);
  @override
  Stream<StateConnect> stateConnectResult() => stateConnectChannel
      .receiveBroadcastStream()
      .map((event) => StateConnect.values[event]);
  @override
  Stream<Log> logResult() => logsChannel
      .receiveBroadcastStream()
      .map((event) => Log.fromBuffer(event))
      .asBroadcastStream();

  @override
  Stream<CharacteristicValue> characteristicResult() => characteristicChannel
      .receiveBroadcastStream()
      .map((event) => CharacteristicValue.fromBuffer(event))
      .asBroadcastStream();
}
