//
//  AMPSEventManager.swift
//  beizi_sdk
//
//  Created by duzhaoquan on 2025/11/10.
//

import Foundation
import Flutter


class BZEventManager : NSObject{
   
    private static let instance = BZEventManager()
    private override init(){ }
    static func getInstance() -> BZEventManager{
        return BZEventManager.instance
    }
    var channel: FlutterMethodChannel?
    var registrar: FlutterPluginRegistrar?
    func regist(_ registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        channel = FlutterMethodChannel(name: "amps_sdk", binaryMessenger:  registrar.messenger())
        channel?.setMethodCallHandler { methodCall, result in
            switch methodCall.method {
//            case let name where  initMethodNames.contains(name):
//                AMPSSDKInitManager.shared.handleMethodCall(methodCall, result: result)
//            case let name where splashMethodNames.contains(name):
//                AMPSSplashManager.getInstance().handleMethodCall(methodCall, result:result)
//            case let name where interstitialMethodNames.contains(name):
//                AMPSInterstitialManager.getInstance().handleMethodCall(methodCall, result: result)
//            case let name where  nativeMethodNames.contains(name):
//                AMPSNativeManager.getInstance().handleMethodCall(methodCall, result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
    }
    func sendToFlutter(_ method:String,arg:Any? = nil){
        channel?.invokeMethod(method, arguments: arg)
    }
    
    func getImage(_ name:String) -> UIImage?  {
        let imageName = name.components(separatedBy: "/").last
        let source = imageName?.components(separatedBy: ".").first
        let type = imageName?.components(separatedBy: ".").last ?? "png"
        
        let tem = "flutter_assets/" + name
        var arr1 = tem.components(separatedBy: "/")
        arr1.removeLast()
        let dir = arr1.joined(separator: "/")
        
        
        if let frameworkPath = Bundle.main.path(forResource: "App", ofType: "framework", inDirectory: "Frameworks"),
           let imagePath = Bundle(path: frameworkPath)?.path(forResource: source, ofType: type, inDirectory: dir) { // 从路径加载图片
            if let image = UIImage(contentsOfFile: imagePath) {
                return image
            }
        }
        return nil
    }
}
