//
//  BeiziInterstitialManager.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/12.
//

import Foundation
import BeiZiSDK
import Flutter




class BeiziInterstitialManager: NSObject {
    
    private static var instance: BeiziInterstitialManager?
    private var interstitialAd: BeiZiInterstitial?
    private var s2sToken : String?

    
    static func getInstance() -> BeiziInterstitialManager {
        if instance == nil {
            instance = BeiziInterstitialManager()
        }
        return instance!
    }
//
    private override init() {}
    
    // MARK: - Public Methods
    func handleMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case BeiZiSdkMethodNames.interstitialCreate:
            handleInterstitialCreate(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.interstitialLoad:
            handleInterstitialLoad(arguments: arguments, result: result)
            result(true)
        case BeiZiSdkMethodNames.interstitialSetBidResponse:
            if let tokon = call.arguments as? String{
                s2sToken = tokon
            }
            result(true)
        case BeiZiSdkMethodNames.interstitialIsLoaded:
            result(true)
        case BeiZiSdkMethodNames.interstitialSetAdVersion:
            if let ver = call.arguments as? Int{
                interstitialAd?.adVersion = ver
            }
            result(true)
        case BeiZiSdkMethodNames.interstitialShowAd:
            handleInterstitialShowAd(arguments: arguments, result: result)
            result(true)
        case BeiZiSdkMethodNames.interstitialGetEcpm:
            result(interstitialAd?.eCPM ?? 0)
        case BeiZiSdkMethodNames.interstitialNotifyRtbWin:
            handleNotifyRTBWin(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.interstitialNotifyRtbLoss:
            handleNotifyRTBLoss(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.interstitialGetCustomParam:
            result(interstitialAd?.customParam)
        case BeiZiSdkMethodNames.interstitialDestroy:
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
        spaceId = "107249"
        let time = param[BeiZiSplashKeys.totalTime] as? UInt64 ?? 5000
        let spaceParam = param[BeiZiSplashKeys.spacePram] as? String ?? ""
        interstitialAd = BeiZiInterstitial(spaceID: spaceId, spaceParam: spaceParam, lifeTime: time)
        result(true)
    }
//    // MARK: - Private Methods
    private func handleInterstitialLoad(arguments: [String: Any]?, result: FlutterResult) {
    
        interstitialAd?.delegate = self
        if let s2sToken = s2sToken {
            interstitialAd?.beiZi_loadAd(withToken: s2sToken)
        }else{
            interstitialAd?.beiZi_loadAd()
        }
        result(true)
    }
    
    private func handleInterstitialShowAd(arguments: [String: Any]?, result: FlutterResult) {
        guard let interstitialAd = interstitialAd else {
            result(false)
            return
        }
        
        guard let vc = getKeyWindow()?.rootViewController else {
            
            result(false)
            return
        }
        interstitialAd.beiZi_showAd(fromRootViewController: vc)
    }
    
    private func handleNotifyRTBWin(arguments: [String: Any]?, result: FlutterResult) {
        guard let arguments =  arguments else{
            return
        }
        let winPrice = arguments[ArgumentKeys.adWinPrice] as? Int ?? 0
        let secPrice = arguments[ArgumentKeys.adSecPrice] as? Int ?? 0
        let adnID = arguments[ArgumentKeys.adnId] as? String ?? ""
        interstitialAd?.sendWinNotification(withInfo: [
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
        
        interstitialAd?.sendLossNotification(withInfo: [
            BeiZi_WIN_PRICE:String(lossWinPrice),
            BeiZi_ADNID:adnId,
            BeiZi_LOSS_REASON:lossReason
        ])
        result(true)
    }

    
    
    private func cleanup() {
        interstitialAd = nil
        s2sToken = nil
    }
    
    private func sendMessage(_ method: String, _ args: Any? = nil) {
        BZEventManager.getInstance().sendToFlutter(method, arg: args)
    }
    
}


extension BeiziInterstitialManager : BeiZiInterstitialDelegate {
    func beiZi_interstitialDidPresentScreen(_ beiziInterstitial: BeiZiInterstitial) {
        sendMessage(BeiZiInterAdCallBackMethod.onAdShown)
    }
    func beiZi_interstitialDidReceiveAd(_ beiziInterstitial: BeiZiInterstitial) {
        sendMessage(BeiZiInterAdCallBackMethod.onAdLoaded)
    }
    func beiZi_interstitialDidClick(_ beiziInterstitial: BeiZiInterstitial) {
        sendMessage(BeiZiInterAdCallBackMethod.onAdClicked)
    }
    func beiZi_interstitialDidDismissScreen(_ beiziInterstitial: BeiZiInterstitial) {
        sendMessage(BeiZiInterAdCallBackMethod.onAdClosed)
    }
    func beiZi_interstitial(_ beiziInterstitial: BeiZiInterstitial, didFailToLoadAdWithError error: BeiZiRequestError) {
        sendMessage(BeiZiInterAdCallBackMethod.onAdFailed, ["code": error.code,"message":error.localizedDescription])

    }

}
