import Flutter
import UIKit

public class BeiziSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      BZEventManager.shared.regist(registrar)
      BZPlatformViewRegistry.shared.regist(registrar)
  }


}
