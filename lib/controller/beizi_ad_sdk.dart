import '../beizi_sdk.dart';
import '../common.dart';
import '../data/beizi_custom_controller.dart';

///SDK初始化入口类
class BeiZis {
  /// 发送数据给native
  static Future<bool> init(
      String appId, BeiziCustomController controller) async {
    return await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.init, controller.toMap(appId));
  }
}
