import 'ble_sdk_platform_interface.dart';

export 'src/generated/blesdk.pbserver.dart';

class BleSdk {
  Future<String?> getPlatformVersion() {
    return BleSdkPlatform.instance.getPlatformVersion();
  }
}
