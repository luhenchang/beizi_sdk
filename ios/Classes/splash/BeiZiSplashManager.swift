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
    
    static let shared: BeiZiSplashManager = .init()
    private override init() {super.init()}
    
    private var splashAd: BeiZiSplash?
    private var s2sToken: String?
    private var bottomView: UIView?
    
    // MARK: - Public Methods
    func handleMethodCall(_ call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
        case BeiZiSdkMethodNames.splashCreate:
            handleSplashCreate(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.splashLoad:
            handleSplashLoad(arguments: arguments, result: result)
        case BeiZiSdkMethodNames.splashSetBidResponse:
            if let tokon = call.arguments as? String{
                s2sToken = tokon
            }
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
        case BeiZiSdkMethodNames.splashCancel:
            self.cleanUp()
            result(true)
        case BeiZiSdkMethodNames.splashSetSpaceParam,
             BeiZiSdkMethodNames.splashGetCustomJsonData:
            result(nil)
        case BeiZiSdkMethodNames.plashGetCustomExtData:
            result(splashAd?.extInfo)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
//    // MARK: - Private Methods
    private func handleSplashCreate(arguments: [String: Any]?, result: FlutterResult) {
    
        guard let param = arguments else {
            result(false)
            return
        }
        guard let spaceId = param[BeiZiSplashKeys.adSpaceId] as? String  else {
            result(false)
            return
        }
//        spaceId = "104833"
        self.bottomView = UIView()
        let time = param[BeiZiSplashKeys.totalTime] as? UInt64 ?? 5000
        let spaceParam = param[BeiZiSplashKeys.spacePram] as? String ?? ""
        splashAd = BeiZiSplash(spaceID: spaceId, spaceParam: spaceParam, lifeTime: time)
        result(true)
    }
    
    private func handleSplashLoad(arguments: [String: Any]?, result: FlutterResult) {
    
        self.createBottomView(arguments)
        splashAd?.delegate = self
        
        if let token = self.s2sToken {
            splashAd?.beiZi_loadAd(withToken: token)
        }else{
            splashAd?.beiZi_loadAd()
        }
        result(true)
    }
    //创建底部自定义view
    private func createBottomView(_ arguments: [String: Any]?){
        guard let arguments = arguments else {
            return
        }
        
        guard let window = getKeyWindow() else {
            return
        }
        if let param = arguments["bottomWidget"] as? [String: Any] {
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
                        imageView.image = BZEventManager.shared.getImage(imageName)
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
    }
    
    private func handleSplashShowAd(arguments: [String: Any]?, result: FlutterResult) {
        guard let splashAd = splashAd else {
            result(false)
            return
        }
        
        if let window = getKeyWindow() {
            splashAd.beiZi_showAd(with: window)
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
        splashAd?.sendWinNotification(withInfo: [
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
        
        splashAd?.sendLossNotification(withInfo: [
            BeiZi_WIN_PRICE:String(lossWinPrice),
            BeiZi_ADNID:adnId,
            BeiZi_LOSS_REASON:lossReason
        ])
        result(true)
    }

    
    private func sendMessage(_ method: String, _ args: Any? = nil) {
        BZEventManager.shared.sendToFlutter(method, arg: args)
    }
    
    private func cleanUp(){
        splashAd?.delegate = nil
        self.splashAd = nil
        self.bottomView = nil
        self.s2sToken = nil
    }
    

}

extension BeiZiSplashManager: BeiZiSplashDelegate {
    func beiZi_splashBottomView() -> UIView {
        return self.bottomView ?? UIView()
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
