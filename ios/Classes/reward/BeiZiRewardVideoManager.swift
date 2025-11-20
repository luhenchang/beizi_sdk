//
//  BeiZiRewardVideoManager.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/12.
//

import Foundation
import BeiZiSDK
import Flutter


class BeiZiRewardVideoManager: NSObject {
    
    static let shared: BeiZiRewardVideoManager = .init()
    private override init() {super.init()}
    
    private var rewardVideoAd: BeiZiRewardedVideo?
    private var s2sToken : String?
    
    // MARK: - Public Methods
    func handleMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case BeiZiSdkMethodNames.rewardedVideoCreate:
            handleRewardVideoCreate(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.rewardedVideoLoad:
            handleRewardVideoLoad(arguments: arguments, result: result)
            result(true)
        case BeiZiSdkMethodNames.rewardedVideoSetBidResponse:
            if let tokon = call.arguments as? String{
                s2sToken = tokon
            }
            result(true)
        case BeiZiSdkMethodNames.rewardedVideoIsLoaded:
            result(rewardVideoAd?.adValid ?? false)
        case BeiZiSdkMethodNames.rewardedVideoShowAd:
            handleRewardVideoShowAd(arguments: arguments, result: result)
            result(true)
        case BeiZiSdkMethodNames.rewardedVideoGetEcpm:
            result(rewardVideoAd?.eCPM ?? 0)
        case BeiZiSdkMethodNames.rewardedVideoNotifyRtbWin:
            handleNotifyRTBWin(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.rewardedVideoNotifyRtbLoss:
            handleNotifyRTBLoss(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.rewardedVideoDestroy:
            self.cleanup()
            result(true)
        case BeiZiSdkMethodNames.rewardedVideoSetSpaceParam,
             BeiZiSdkMethodNames.rewardedVideoGetCustomJsonData:
            result(nil)
        case BeiZiSdkMethodNames.rewardedVideoGetExtra:
            result(rewardVideoAd?.extraInfo)
        case BeiZiSdkMethodNames.rewardedVideoSetExtra:
            if let arguments = call.arguments as? String{
                rewardVideoAd?.extraInfo = arguments
            }
        case BeiZiSdkMethodNames.rewardedVideoGetUserId:
            result(rewardVideoAd?.userID)
        case BeiZiSdkMethodNames.rewardedVideoSetUserId:
            if let id = call.arguments as? String {
                rewardVideoAd?.userID = id
            }
        case BeiZiSdkMethodNames.rewardedVideoGetCustomExtData:
            result(rewardVideoAd?.extInfo)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
//
    private func handleRewardVideoCreate(arguments: [String: Any]?, result: FlutterResult) {
    
        guard let param = arguments else {
            result(false)
            return
        }
        guard let spaceId = param[BeiZiSplashKeys.adSpaceId] as? String  else {
            result(false)
            return
        }
//        spaceId = "111367"
        let time = param[BeiZiSplashKeys.totalTime] as? UInt64 ?? 5000
        let spaceParam = param[BeiZiSplashKeys.spacePram] as? String ?? ""
        rewardVideoAd = BeiZiRewardedVideo(spaceID: spaceId, spaceParam: spaceParam, lifeTime: time)
        result(true)
    }
//    // MARK: - Private Methods
    private func handleRewardVideoLoad(arguments: [String: Any]?, result: FlutterResult) {
    
        rewardVideoAd?.delegate = self
        if let s2sToken = s2sToken {
            rewardVideoAd?.beiZi_loadAd(withToken: s2sToken)
        }else{
            rewardVideoAd?.beiZi_loadAd()
        }
        result(true)
    }
    
    private func handleRewardVideoShowAd(arguments: [String: Any]?, result: FlutterResult) {
        guard let rewardVideoAd = rewardVideoAd else {
            result(false)
            return
        }
        
        guard let vc = getKeyWindow()?.rootViewController else {
            
            result(false)
            return
        }
        
        rewardVideoAd.beiZi_showAd(fromRootViewController: vc)
    }
    
    private func handleNotifyRTBWin(arguments: [String: Any]?, result: FlutterResult) {
        guard let arguments =  arguments else{
            return
        }
        let winPrice = arguments[ArgumentKeys.adWinPrice] as? Int ?? 0
        let secPrice = arguments[ArgumentKeys.adSecPrice] as? Int ?? 0
        let adnID = arguments[ArgumentKeys.adnId] as? String ?? ""
        rewardVideoAd?.sendWinNotification(withInfo: [
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
        
        rewardVideoAd?.sendLossNotification(withInfo: [
            BeiZi_WIN_PRICE:String(lossWinPrice),
            BeiZi_ADNID:adnId,
            BeiZi_LOSS_REASON:lossReason
        ])
        result(true)
    }

    
    
    private func cleanup() {
        rewardVideoAd = nil
        s2sToken = nil
    }
    
    private func sendMessage(_ method: String, _ args: Any? = nil) {
        BZEventManager.shared.sendToFlutter(method, arg: args)
    }
    
}


//
extension BeiZiRewardVideoManager : BeiZiRewardedVideoDelegate {
    func beiZi_rewardedVideoDidReceiveAd(_ beiziRewardedVideo: BeiZiRewardedVideo) {
        sendMessage(BeiZiRewardedVideoAdChannelMethod.onRewardedVideoAdLoaded)
    }
    func beiZi_rewardedVideoDidStartPlay(_ beiziRewardedVideo: BeiZiRewardedVideo) {
        sendMessage(BeiZiRewardedVideoAdChannelMethod.onRewardedVideoAdShown)
    }
    func beiZi_rewardedVideoDidDismissScreen(_ beiziRewardedVideo: BeiZiRewardedVideo) {
        sendMessage(BeiZiRewardedVideoAdChannelMethod.onRewardedVideoAdClosed)
    }
    func beiZi_rewardedVideoDidClick(_ beiziRewardedVideo: BeiZiRewardedVideo) {
        sendMessage(BeiZiRewardedVideoAdChannelMethod.onRewardedVideoClick)
    }
    func beiZi_rewardedVideoDidPlayEnd(_ beiziRewardedVideo: BeiZiRewardedVideo) {
        sendMessage(BeiZiRewardedVideoAdChannelMethod.onRewardedVideoComplete)
    }
    func beiZi_rewardedVideo(_ beiziRewardedVideo: BeiZiRewardedVideo, didRewardUserWithReward reward: NSObject) {
        sendMessage(BeiZiRewardedVideoAdChannelMethod.onRewarded)
    }
    func beiZi_rewardedVideo(_ beiziRewardedVideo: BeiZiRewardedVideo, didFailToLoadAdWithError error: BeiZiRequestError) {
        sendMessage(BeiZiRewardedVideoAdChannelMethod.onRewardedVideoAdFailedToLoad,["code": error.code,"message":error.localizedDescription])
    }
    
}
