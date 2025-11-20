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
    
    // MARK: - Singleton Pattern
    static let shared = BeiZiUnifiedNativeManager()
    private override init() {
        super.init()
    }
    
    // MARK: - Properties
    private var unifiedNative: BeiZiUnifiedNative?
    private var s2sToken: String?
    
    // MARK: - Public Methods
    func getUnifiedAd(_ adId: String) -> BeiZiUnifiedNative? {
        return unifiedNative
    }
    
    func handleMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        
        switch call.method {
        case BeiZiSdkMethodNames.unifiedNativeCreate:
            handleUnifiedNativeCreate(arguments: arguments, result: result)
            
        case BeiZiSdkMethodNames.unifiedNativeLoad:
            handleUnifiedNativeLoad(arguments: arguments, result: result)
            
        case BeiZiSdkMethodNames.unifiedNativeSetBidResponse:
            handleSetBidResponse(call.arguments, result: result)
            
        case BeiZiSdkMethodNames.unifiedNativeSetHide,
             BeiZiSdkMethodNames.unifiedNativeResume,
             BeiZiSdkMethodNames.unifiedNativePause,
             BeiZiSdkMethodNames.unifiedNativeSetSpaceParam:
            result(true)
            
        case BeiZiSdkMethodNames.unifiedNativeGetDownLoad,
             BeiZiSdkMethodNames.unifiedNativeGetCustomJsonData:
            result(nil) // 更简洁的空字典写法
            
        case BeiZiSdkMethodNames.unifiedNativeMaterialType:
            handleGetMaterialType(result: result)
            
        case BeiZiSdkMethodNames.unifiedNativeGetEcpm:
            result(unifiedNative?.eCPM ?? 0)
            
        case BeiZiSdkMethodNames.unifiedNativeNotifyRtbWin:
            handleNotifyRTBWin(arguments: arguments, result: result)
            
        case BeiZiSdkMethodNames.unifiedNativeNotifyRtbLoss:
            handleNotifyRTBLoss(arguments: arguments, result: result)
            
        case BeiZiSdkMethodNames.unifiedNativeGetCustomParam:
            result(unifiedNative?.customParam)
            
        case BeiZiSdkMethodNames.nativeUnifiedGetCustomExtData:
            result(unifiedNative?.extInfo)
            
        case BeiZiSdkMethodNames.nativeDestroy:
            cleanup()
            result(true)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Private Methods
    
    private func handleUnifiedNativeCreate(arguments: [String: Any]?, result: FlutterResult) {
        guard let param = arguments,
              let spaceId = param[BeiZiSplashKeys.adSpaceId] as? String else {
            result(false)
            return
        }
        
        cleanup()
        //"106063"
        let totalTime = param[BeiZiSplashKeys.totalTime] as? UInt64 ?? 5000
        let spaceParam = param[BeiZiSplashKeys.spacePram] as? String ?? ""
        
        unifiedNative = BeiZiUnifiedNative(
            spaceID: spaceId,
            spaceParam: spaceParam,
            lifeTime: totalTime
        )
        unifiedNative?.rootViewController = getKeyWindow()?.rootViewController
        
        result(true)
    }
    
    private func handleUnifiedNativeLoad(arguments: [String: Any]?, result: FlutterResult) {
        unifiedNative?.delegate = self
        
        if let token = s2sToken {
            unifiedNative?.beiZi_load(withToken: token)
        } else {
            unifiedNative?.beiZi_load()
        }
        
        result(true)
    }
    
    private func handleSetBidResponse(_ arguments: Any?, result: FlutterResult) {
        if let token = arguments as? String {
            s2sToken = token
        }
        result(true)
    }
    
    private func handleGetMaterialType(result: FlutterResult) {
        if let isVideoAd = unifiedNative?.dataObject.isVideoAd {
            result(isVideoAd ? 1 : 2)
        } else {
            result(0)
        }
    }
    
    private func handleNotifyRTBWin(arguments: [String: Any]?, result: FlutterResult) {
        guard let arguments = arguments else {
            result(false)
            return
        }
        
        let winPrice = arguments[ArgumentKeys.adWinPrice] as? Int ?? 0
        let secPrice = arguments[ArgumentKeys.adSecPrice] as? Int ?? 0
        let adnID = arguments[ArgumentKeys.adnId] as? String ?? ""
        
        let winInfo = [
            BeiZi_WIN_PRICE: String(winPrice),
            BeiZi_HIGHRST_LOSS_PRICE: String(secPrice),
            BeiZi_ADNID: adnID
        ]
        
        unifiedNative?.sendWinNotification(withInfo: winInfo)
        result(true)
    }
    
    private func handleNotifyRTBLoss(arguments: [String: Any]?, result: FlutterResult) {
        guard let arguments = arguments else {
            result(false)
            return
        }
        
        let lossWinPrice = arguments[ArgumentKeys.adWinPrice] as? Int ?? 0
        let adnId = arguments[ArgumentKeys.adnId] as? String ?? ""
        let lossReason = arguments[ArgumentKeys.adLossReason] as? String ?? ""
        
        let lossInfo = [
            BeiZi_WIN_PRICE: String(lossWinPrice),
            BeiZi_ADNID: adnId,
            BeiZi_LOSS_REASON: lossReason
        ]
        
        unifiedNative?.sendLossNotification(withInfo: lossInfo)
        result(true)
    }
    
    private func cleanup() {
        unifiedNative?.delegate = nil
        unifiedNative = nil
        s2sToken = nil
    }
    
    private func sendMessage(_ method: String, _ args: Any? = nil) {
        BZEventManager.shared.sendToFlutter(method, arg: args)
    }
}

// MARK: - BeiZiUnifiedNativeDelegate
extension BeiZiUnifiedNativeManager: BeiZiUnifiedNativeDelegate {
    
    func beiZi_unifiedNativeDidLoadSuccess(_ unifiedNative: BeiZiUnifiedNative) {
        sendMessage(BeiZiNativeUnifiedAdChannelMethod.onAdLoaded, UUID().uuidString)
    }
    
    func beiZi_unifiedNativePresentScreen(_ unifiedNative: BeiZiUnifiedNative) {
        sendMessage(BeiZiNativeUnifiedAdChannelMethod.onAdShown)
    }
    
    func beiZi_unifiedNativeDidClick(_ unifiedNative: BeiZiUnifiedNative) {
        sendMessage(BeiZiNativeUnifiedAdChannelMethod.onAdClick)
    }
    
    func beiZi_unifiedNative(_ unifiedNative: BeiZiUnifiedNative,
                           didFailToLoadAdWithError error: BeiZiRequestError) {
        let errorInfo = [
            "code": error.code,
            "message": error.localizedDescription
        ] as [String : Any]
        sendMessage(BeiZiNativeUnifiedAdChannelMethod.onAdFailed, errorInfo)
    }
}
