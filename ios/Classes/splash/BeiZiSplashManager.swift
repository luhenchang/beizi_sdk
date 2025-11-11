//
//  BeiZiSplashManager.swift
//  beizi_sdk
//
//  Created by duzhaoquan on 2025/11/10.
//

import Foundation
import Flutter
import BeiZiSDK



class BeiZiSplashManager: NSObject {
    
    private static var instance: BeiZiSplashManager?
    private var splashAd: BeiZiSplash?
    private var bottomView: UIView = UIView()

    // Singleton
    static func getInstance() -> BeiZiSplashManager {
        if instance == nil {
            instance = BeiZiSplashManager()
        }
        return instance!
    }
    private override init() {}
    
    // MARK: - Public Methods
    func handleMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case BeiZiSdkMethodNames.splashCreate:
            handleSplashCreate(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.splashLoad:
            handleSplashLoad(arguments: arguments, result: result)
            result(true)
        case BeiZiSdkMethodNames.splashShowAd:
            handleSplashShowAd(arguments: arguments, result: result)
            result(true)
        case BeiZiSdkMethodNames.splashGetEcpm:
            result(splashAd?.eCPM ?? 0)
        case BeiZiSdkMethodNames.splashNotifyRtbWin:
            handleNotifyRTBWin(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.splashNotifyRtbLoss:
            handleNotifyRTBLoss(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.splashGetCustomParam:
            result(self.splashAd?.customParam)
        case BeiZiSdkMethodNames.splashGetAnyParam:
            result(self.splashAd?.anyParam)
        case BeiZiSdkMethodNames.splashSetSpaceParam:
            result(self.splashAd?.spaceParam)
        default:
            result(false)
        }
    }
    
//    // MARK: - Private Methods
    private func handleSplashCreate(arguments: [String: Any]?, result: FlutterResult) {
    
        guard let param = arguments else {
            result(false)
            return
        }
        guard var spaceId = param[BeiZiSplashKeys.adSpaceId] as? String  else {
            result(false)
            return
        }
        spaceId = "104833"
        let time = param[BeiZiSplashKeys.totalTime] as? UInt64 ?? 5000
        splashAd = BeiZiSplash(spaceID: spaceId, spaceParam: "", lifeTime: time)
        result(true)
    }
    private func handleSplashLoad(arguments: [String: Any]?, result: FlutterResult) {
    
//        guard let param = arguments else {
//            return
//        }
        splashAd?.delegate = self
        splashAd?.beiZi_loadAd()
        result(true)
    }
    
    private func handleSplashShowAd(arguments: [String: Any]?, result: FlutterResult) {
        guard let splashAd = splashAd else {
            result(false)
            return
        }
        
        guard let window = getKeyWindow() else {
            
            result(false)
            return
        }
        if let param = arguments {
            let height = param["height"]  as? CGFloat ?? 0
            let bgColor = param["backgroundColor"] as? String
            var imageModel: SplashBottomImage?
            var textModel: SplashBottomText?
            if let children = param["children"] as? [[String: Any]] {
                children.forEach { child in
                    let type = child["type"] as? String ?? ""
                    if type == "image"{
                        imageModel = Tools.convertToModel(from: child)
                    }else if type == "text" {
                        textModel = Tools.convertToModel(from: child)
                    }
                }
            }
            if height > 1 {
                let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(window.bounds.width), height: height))
                if let bgColor = bgColor{
                    bottomView.backgroundColor = UIColor(hexString: bgColor)
                }
                
                if let imageModel = imageModel {
                    let imageView = UIImageView(frame: CGRect(x: imageModel.x ?? 0, y: imageModel.y ?? 0, width: imageModel.width ?? 100, height: imageModel.height ?? 100))
                    if let imageName =  imageModel.imagePath {
                        imageView.image = BZEventManager.getInstance().getImage(imageName)
                    }
                    
                    bottomView.addSubview(imageView)
                    imageView.backgroundColor  = UIColor.orange
                }
                if let text = textModel?.text {
                    let widht = window.bounds.width - (textModel?.x ?? 0)
                    let tagLabel = UILabel(frame: CGRect(x: textModel?.x ?? 0, y: textModel?.y ?? 0, width: widht, height: 0))
                    tagLabel.numberOfLines = 0
                    if let color = textModel?.color {
                        tagLabel.textColor = UIColor(hexString: color)
                    }
                    tagLabel.text = text
                    if let font = textModel?.fontSize {
                        tagLabel.font = UIFont.systemFont(ofSize: font)
                    }
                    bottomView.addSubview(tagLabel)
                    let fittingSize = tagLabel.sizeThatFits(CGSize(width: widht, height: CGFloat.greatestFiniteMagnitude))
                    tagLabel.frame.size.height = fittingSize.height // 应用计算出的高度
                }
                
                
                self.bottomView = bottomView
                
                
            }
            
        }
       
            
        if let window = getKeyWindow() {
            splashAd.beiZi_showAd(with: window)
        }
        

    }
    
    private func handleNotifyRTBWin(arguments: [String: Any]?, result: FlutterResult) {
        guard let arguments =  arguments else{
            return
        }
        let winPrice = arguments[ArgumentKeys.adWinPrice] as? Int ?? 0
        let secPrice = arguments[ArgumentKeys.adSecPrice] as? Int ?? 0
        splashAd?.sendWinNotification(withInfo: [BidKeys.winPrince:String(winPrice),BidKeys.lossSecondPrice:String(secPrice)])
        result(true)
    }
    
    private func handleNotifyRTBLoss(arguments: [String: Any]?, result: FlutterResult) {
        guard let arguments =  arguments else{
            return
        }
        let lossWinPrice = arguments[ArgumentKeys.adWinPrice] as? Int ?? 0
        let lossSecPrice = arguments[ArgumentKeys.adSecPrice] as? Int ?? 0
        let lossReason = arguments[ArgumentKeys.adLossReason] as? String ?? ""
        
        splashAd?.sendLossNotification(withInfo: [
            BidKeys.winPrince:String(lossWinPrice),
            BidKeys.lossSecondPrice:String(lossSecPrice),
            BidKeys.lossReason:lossReason
        ])
        result(true)
    }
    
    private func cleanupExistingSplashViews() {
        UIApplication.shared.windows.forEach { window in
            window.subviews.forEach { subview in
                if subview.tag == 12345 { // Match the tag used for main container
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    private func cleanupViewsAfterAdClosed() {
        cleanupExistingSplashViews()
        splashAd = nil
    }
    
    private func sendMessage(_ method: String, _ args: Any? = nil) {
        BZEventManager.getInstance().sendToFlutter(method, arg: args)
    }
    

}

extension BeiZiSplashManager: BeiZiSplashDelegate {
    func beiZi_splashBottomView() -> UIView {
        return self.bottomView
    }
    
    func beiZi_splashDidLoadSuccess(_ beiziSplash: BeiZiSplash) {
        sendMessage(BeiZiAdCallBackChannelMethod.onAdLoaded)
    }
    
    func beiZi_splash(_ beiziSplash: BeiZiSplash, didFailToLoadAdWithError error: BeiZiRequestError) {
        sendMessage(BeiZiAdCallBackChannelMethod.onAdFailedToLoad,["code": error.code,"message":error.localizedDescription])
    }
    
    func beiZi_splashAdLifeTime(_ lifeTime: Int32) {
        sendMessage(BeiZiAdCallBackChannelMethod.onAdTick,lifeTime)
    }
    
    func beiZi_splashDidPresentScreen(_ beiziSplash: BeiZiSplash) {
        sendMessage(BeiZiAdCallBackChannelMethod.onAdShown)
    }
    
    func beiZi_splashDidClick(_ beiziSplash: BeiZiSplash) {
        sendMessage(BeiZiAdCallBackChannelMethod.onAdClicked)
    }
    
    func beiZi_splashWillDismissScreen(_ beiziSplash: BeiZiSplash) {
        
    }
    func beiZi_splashDidDismissScreen(_ beiziSplash: BeiZiSplash) {
        sendMessage(BeiZiAdCallBackChannelMethod.onAdClosed)
        
    }
}



struct SplashBottomImage : Codable{
    var x: CGFloat?
    var y: CGFloat?
    var imagePath: String?
    var width: CGFloat?
    var height: CGFloat?
}


struct SplashBottomText: Codable{
    var x: CGFloat?
    var y: CGFloat?
    var text: String?
    var width: CGFloat?
    var height: CGFloat?
    var color: String?
    var fontSize: CGFloat?
}
