import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ble_sdk_platform_interface.dart';

/// An implementation of [BleSdkPlatform] that uses method channels.
class MethodChannelBleSdk extends BleSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ble_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
