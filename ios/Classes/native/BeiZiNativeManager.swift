//
//  BeiZiNativeManager.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/13.
//

import Foundation
import BeiZiSDK
import Flutter


class BeiZiNativeManager: NSObject {
     
    static let shared: BeiZiNativeManager = .init()
    private override init() {super.init()}
    
    var nativeExpress: BeiZiNativeExpress?
    var s2sToken: String?
    
    func getAdView(_ adId: String) -> UIView? {
        let adView = self.nativeExpress?.channeNativeAdView.first as? UIView
        return adView
    }
    
    
    // MARK: - Public Methods
    func handleMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case BeiZiSdkMethodNames.nativeCreate:
            handleInterstitialCreate(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.nativeLoad:
            handleInterstitialLoad(arguments: arguments, result: result)
            result(true)
        case BeiZiSdkMethodNames.nativeSetBidResponse:
            if let tokon = call.arguments as? String{
                s2sToken = tokon
            }
            result(true)
        case BeiZiSdkMethodNames.nativePause,
             BeiZiSdkMethodNames.nativeResume,
             BeiZiSdkMethodNames.nativeSetSpaceParam,
             BeiZiSdkMethodNames.nativeGetCustomJsonData:
            result(nil)
        case BeiZiSdkMethodNames.nativeGetEcpm:
            result(nativeExpress?.eCPM ?? 0)
        case BeiZiSdkMethodNames.nativeNotifyRtbWin:
            handleNotifyRTBWin(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.nativeNotifyRtbLoss:
            handleNotifyRTBLoss(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.nativeGetCustomParam:
            result(nativeExpress?.customParam)
        case BeiZiSdkMethodNames.nativeDestroy:
            self.cleanup()
            result(true)
        case BeiZiSdkMethodNames.nativeGetCustomExtData:
            result(nativeExpress?.extInfo)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
//
    private func handleInterstitialCreate(arguments: [String: Any]?, result: FlutterResult) {
    
        guard let param = arguments else {
            result(false)
            return
        }
        guard let spaceId = param[BeiZiSplashKeys.adSpaceId] as? String  else {
            result(false)
            return
        }
//        spaceId = "106043"
        cleanup()//清除
        let time = param[BeiZiSplashKeys.totalTime] as? UInt64 ?? 5000
        let spaceParam = param[BeiZiSplashKeys.spacePram] as? String ?? ""
        nativeExpress = BeiZiNativeExpress(spaceID: spaceId, spaceParam: spaceParam, lifeTime: time)
        nativeExpress?.beiziNativeViewController = UIViewController.current()
        result(true)
    }
    // MARK: - Private Methods
    private func handleInterstitialLoad(arguments: [String: Any]?, result: FlutterResult) {
        
        let w = arguments?["width"] as? CGFloat ?? UIScreen.main.bounds.size.width
        let h = arguments?["height"] as? CGFloat ?? 100
    
        nativeExpress?.delegate = self
        if let s2sToken = s2sToken {
            nativeExpress?.beiZi_loadAd(withViewSize: CGSize(width: w, height: h), token: s2sToken)
        }else{
            nativeExpress?.beiZi_loadAd(withViewSize: CGSize(width: w, height: h))
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
        nativeExpress?.sendWinNotification(withInfo: [
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
        
        nativeExpress?.sendLossNotification(withInfo: [
            BeiZi_WIN_PRICE:String(lossWinPrice),
            BeiZi_ADNID:adnId,
            BeiZi_LOSS_REASON:lossReason
        ])
        result(true)
    }

    
    
    private func cleanup() {
        nativeExpress = nil
        s2sToken = nil
    }
    
    private func sendMessage(_ method: String, _ args: Any? = nil) {
        BZEventManager.shared.sendToFlutter(method, arg: args)
    }
    
}


extension BeiZiNativeManager : BeiZiNativeExpressDelegate {
    func beiZi_nativeExpressDidLoad(_ beiziNativeExpress: BeiZiNativeExpress) {
        sendMessage(BeiZiNativeAdChannelMethod.onAdLoaded,UUID().uuidString)
    }
    func beiZi_nativeExpress(_ beiziNativeExpress: BeiZiNativeExpress, didFailToLoadAdWithError error: BeiZiRequestError) {
        sendMessage(BeiZiNativeAdChannelMethod.onAdFailed, ["code": error.code,"message":error.localizedDescription])
    }
    func beiZi_nativeExpressDidShow(_ beiziNativeExpress: BeiZiNativeExpress) {
        sendMessage(BeiZiNativeAdChannelMethod.onAdShown)
    }
    func beiZi_nativeExpressDidClick(_ beiziNativeExpress: BeiZiNativeExpress) {
        sendMessage(BeiZiNativeAdChannelMethod.onAdClick)
    }
    func beiZi_nativeExpressDislikeDidClick(_ beiziNativeExpress: BeiZiNativeExpress) {
        
    }

}

    
    
    
    

