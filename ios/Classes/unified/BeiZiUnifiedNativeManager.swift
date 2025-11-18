//
//  BeiZiUnifiedNativeManager.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/17.
//

import Foundation
import BeiZiSDK
import Flutter

class BeiZiUnifiedNativeManager: NSObject {
    
    static private var instance: BeiZiUnifiedNativeManager?
   
    static func getInstance() -> BeiZiUnifiedNativeManager{
        if (BeiZiUnifiedNativeManager.instance == nil) {
            BeiZiUnifiedNativeManager.instance = BeiZiUnifiedNativeManager()
        }
        return BeiZiUnifiedNativeManager.instance!
    }
    private override init() {super.init()}
    
    var unifiedNative: BeiZiUnifiedNative?
    var s2sToken: String?
    
    func getUnifiedAd(_ adId: String) -> BeiZiUnifiedNative? {
        let adView = self.unifiedNative
        
        return adView
    }
    // MARK: - Public Methods
    func handleMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as? [String: Any]
    
        switch call.method {
        case BeiZiSdkMethodNames.unifiedNativeCreate:
            handleInterstitialCreate(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.unifiedNativeLoad:
            handleInterstitialLoad(arguments: arguments, result: result)
            result(true)
        case BeiZiSdkMethodNames.unifiedNativeSetBidResponse:
            if let tokon = call.arguments as? String{
                s2sToken = tokon
            }
            result(true)
        case BeiZiSdkMethodNames.unifiedNativeSetHide:
            result(true)
        case BeiZiSdkMethodNames.unifiedNativeResume:
            result(true)
        case BeiZiSdkMethodNames.unifiedNativePause:
            result(true)
        case BeiZiSdkMethodNames.unifiedNativeSetSpaceParam:
            result(true)
        case BeiZiSdkMethodNames.unifiedNativeGetDownLoad:
            result(["":""])
        case BeiZiSdkMethodNames.unifiedNativeMaterialType:
            if let unified = unifiedNative?.dataObject.isVideoAd {
                result(unified ? 1 : 2)
            }else{
                result(0)
            }
        case BeiZiSdkMethodNames.unifiedNativeGetEcpm:
            result(unifiedNative?.eCPM ?? 0)
        case BeiZiSdkMethodNames.unifiedNativeNotifyRtbWin:
            handleNotifyRTBWin(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.unifiedNativeNotifyRtbLoss:
            handleNotifyRTBLoss(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.unifiedNativeGetCustomParam:
            result(unifiedNative?.customParam)
        case BeiZiSdkMethodNames.nativeDestroy:
            self.cleanup()
            result(true)
        default:
            result(nil)
        }
    }
//
    private func handleInterstitialCreate(arguments: [String: Any]?, result: FlutterResult) {
    
        guard let param = arguments else {
            result(false)
            return
        }
        guard var spaceId = param[BeiZiSplashKeys.adSpaceId] as? String  else {
            result(false)
            return
        }
//        spaceId = "106063"
        cleanup()//清除
        let time = param[BeiZiSplashKeys.totalTime] as? UInt64 ?? 5000
        let spaceParam = param[BeiZiSplashKeys.spacePram] as? String ?? ""
        unifiedNative = BeiZiUnifiedNative(spaceID: spaceId, spaceParam: spaceParam, lifeTime: time)
        unifiedNative?.rootViewController = getKeyWindow()?.rootViewController
        result(true)
    }
    // MARK: - Private Methods
    private func handleInterstitialLoad(arguments: [String: Any]?, result: FlutterResult) {
            
        unifiedNative?.delegate = self
        if let s2sToken = s2sToken {
            unifiedNative?.beiZi_load(withToken: s2sToken)
        }else{
            unifiedNative?.beiZi_load()
        
        }
        result(true)
    }
    
    private func handleNotifyRTBWin(arguments: [String: Any]?, result: FlutterResult) {
        guard let arguments =  arguments else{
            return
        }
        let winPrice = arguments[ArgumentKeys.adWinPrice] as? Int ?? 0
        let secPrice = arguments[ArgumentKeys.adSecPrice] as? Int ?? 0
        let adnID = arguments[ArgumentKeys.adnId] as? String ?? ""
        unifiedNative?.sendWinNotification(withInfo: [
            BeiZi_WIN_PRICE:String(winPrice),
            BeiZi_HIGHRST_LOSS_PRICE:String(secPrice),
            BeiZi_ADNID: adnID
        ])
        result(true)
    }
    
    private func handleNotifyRTBLoss(arguments: [String: Any]?, result: FlutterResult) {
        guard let arguments =  arguments else{
            return
        }
        let lossWinPrice = arguments[ArgumentKeys.adWinPrice] as? Int ?? 0
        let adnId = arguments[ArgumentKeys.adnId] as? String ?? ""
        let lossReason = arguments[ArgumentKeys.adLossReason] as? String ?? ""
        
        unifiedNative?.sendLossNotification(withInfo: [
            BeiZi_WIN_PRICE:String(lossWinPrice),
            BeiZi_ADNID:adnId,
            BeiZi_LOSS_REASON:lossReason
        ])
        result(true)
    }

    
    
    private func cleanup() {
        unifiedNative = nil
        s2sToken = nil
    }
    
    private func sendMessage(_ method: String, _ args: Any? = nil) {
        BZEventManager.getInstance().sendToFlutter(method, arg: args)
    }
}


extension BeiZiUnifiedNativeManager :BeiZiUnifiedNativeDelegate{
    func beiZi_unifiedNativeDidLoadSuccess(_ unifiedNative: BeiZiUnifiedNative) {
        sendMessage(BeiZiNativeUnifiedAdChannelMethod.onAdLoaded,UUID().uuidString)
    }
    func beiZi_unifiedNativePresentScreen(_ unifiedNative: BeiZiUnifiedNative) {
        sendMessage(BeiZiNativeUnifiedAdChannelMethod.onAdShown)
    }
    func beiZi_unifiedNativeDidClick(_ unifiedNative: BeiZiUnifiedNative) {
        sendMessage(BeiZiNativeUnifiedAdChannelMethod.onAdClick)
    }
    func beiZi_unifiedNative(_ unifiedNative: BeiZiUnifiedNative, didFailToLoadAdWithError error: BeiZiRequestError) {
        sendMessage(BeiZiNativeUnifiedAdChannelMethod.onAdFailed,["code": error.code,"message":error.localizedDescription])

    }

}
