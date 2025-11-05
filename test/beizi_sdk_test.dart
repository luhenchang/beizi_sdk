import 'package:flutter_test/flutter_test.dart';
import 'package:beizi_sdk/beizi_sdk.dart';
import 'package:beizi_sdk/beizi_sdk_platform_interface.dart';
import 'package:beizi_sdk/beizi_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBeiziSdkPlatform
    with MockPlatformInterfaceMixin
    implements BeiziSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BeiziSdkPlatform initialPlatform = BeiziSdkPlatform.instance;

  test('$MethodChannelBeiziSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBeiziSdk>());
  });

  test('getPlatformVersion', () async {
    BeiziSdk beiziSdkPlugin = BeiziSdk();
    MockBeiziSdkPlatform fakePlatform = MockBeiziSdkPlatform();
    BeiziSdkPlatform.instance = fakePlatform;

    //expect(await beiziSdkPlugin.getPlatformVersion(), '42');
  });
}
