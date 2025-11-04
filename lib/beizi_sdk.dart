
import 'beizi_sdk_platform_interface.dart';

class BeiziSdk {
  Future<String?> getPlatformVersion() {
    return BeiziSdkPlatform.instance.getPlatformVersion();
  }
}
