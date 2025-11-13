import Flutter
import UIKit

public class BeiziSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      BZEventManager.getInstance().regist(registrar)
      BZPlatformViewRegistry.getInstance().regist(registrar)
  }


}
