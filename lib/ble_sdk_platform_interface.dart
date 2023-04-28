import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ble_sdk_method_channel.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
