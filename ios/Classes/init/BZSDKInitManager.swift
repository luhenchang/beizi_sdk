//
//  BZSDKInitManager.swift
//  beizi_sdk
//
//  Created by duzhaoquan on 2025/11/10.
//

import Foundation
import Flutter
import BeiZiSDK


class BZSDKInitManager {
    static let shared: BZSDKInitManager = .init()
    private init() {}
    
    func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method
        let flutterParams = call.arguments as? [String: Any]
        switch method {
        case BeiZiSdkMethodNames.initSDK:
            initAMPSSDK(flutterParams)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func initAMPSSDK(_ flutterParams: [String:Any]?) {
        guard let flutterParams = flutterParams else {
            return
        }
        let initParam: InitParamModel? = Tools.convertToModel(from: flutterParams)
        let appid = initParam?.appId ?? ""
//        let appid =  "20825"
        var useData: [String:String] = [:]
        let canUseLocation = initParam?.canUseLocation ?? true
        useData["isLocation"] = canUseLocation ? "1" : "0"
        if let coordinate = initParam?.type{
            useData["type"] = coordinate + ""
        }
        if let latitude = initParam?.latitude {
           useData["lat"] =  String(latitude)
        }
        if let longitude = initParam?.longitude{
           useData["lng"] = String(longitude)
        }
        if let timeStamp = initParam?.time{
           useData["locTime"] = String(timeStamp)
        }
        BeiZiSDKManager.setExtraUserData(useData)
        if let close = initParam?.shouldForbidSensor,close == true{
            BeiZiSDKManager.closeShakeInteraction()
        }
        if let idfa = initParam?.devOaid {
            BeiZiSDKManager.setCustomIDFA(idfa)
        }
        BeiZiSDKManager.setPersonalRecommend(initParam?.isPersonalRecommend ?? true)
        BeiZiSDKManager.configure(withApplicationID: appid)
    
    }
    
    func sendMessage(_ method: String, args: Any? = nil) {
        BZEventManager.shared.sendToFlutter(method)
    }
}

/*

appid "20825"
开屏"104833"
插屏"107249"
激励视频"111367"
原生"106043"
自渲染"106063"


*/
