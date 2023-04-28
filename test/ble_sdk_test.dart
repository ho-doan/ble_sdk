import 'package:flutter_test/flutter_test.dart';
import 'package:ble_sdk/ble_sdk.dart';
import 'package:ble_sdk/ble_sdk_platform_interface.dart';
import 'package:ble_sdk/ble_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBleSdkPlatform
    with MockPlatformInterfaceMixin
    implements BleSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BleSdkPlatform initialPlatform = BleSdkPlatform.instance;

  test('$MethodChannelBleSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBleSdk>());
  });

  test('getPlatformVersion', () async {
    BleSdk bleSdkPlugin = BleSdk();
    MockBleSdkPlatform fakePlatform = MockBleSdkPlatform();
    BleSdkPlatform.instance = fakePlatform;

    expect(await bleSdkPlugin.getPlatformVersion(), '42');
  });
}
