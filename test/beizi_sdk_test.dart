import 'package:flutter_test/flutter_test.dart';
import 'package:beizi_sdk/beizi_sdk.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBeiziSdkPlatform
    with MockPlatformInterfaceMixin {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  test('getPlatformVersion', () async {
    BeiziSdk beiziSdkPlugin = BeiziSdk();
    MockBeiziSdkPlatform fakePlatform = MockBeiziSdkPlatform();
  });
}
