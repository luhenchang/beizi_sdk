//
//  BeiziUnifiedNativeView.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/17.
//

import Foundation
import Flutter
import BeiZiSDK


class BeiZiUnifiedNAtiveViewFactory: NSObject, FlutterPlatformViewFactory {
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        return BeiZiSelfRenderView(frame: frame, viewId: viewId, args: args)
    }
    
    func createArgsCodec() -> any FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    
}
      
class BeiZiSelfRenderView : NSObject, FlutterPlatformView {
    
    private var iosView: UIView
    init(frame: CGRect,viewId: Int64,args:Any?) {
        self.iosView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        super.init()
        self.iosView.backgroundColor = UIColor.orange
        
        if let param = args as? [String: Any?]{
            let model: FlutterUnifiedParam? = Tools.convertToModel(from: param as [String : Any])
            if let adId = model?.adId {
                if let ad = BeiZiUnifiedNativeManager.getInstance().getUnifiedAd(adId) {
                    let adView = ad.materialView
                    self.iosView.frame.size.width =  model?.unifiedWidget?.width ?? UIScreen.main.bounds.width
                    self.iosView.frame.size.height = model?.unifiedWidget?.height ?? 200
                    adView.frame  =  CGRect(x:0, y: 0, width: self.iosView.frame.size.width, height: self.iosView.frame.size.height)
                    if let bgColor = model?.unifiedWidget?.backgroundColor {
                        
                        adView.backgroundColor = UIColor(hexString: bgColor)
                        
                    }
                    
                    self.iosView.addSubview(adView)
                   
                    self.layoutItems(adView,ad,model!)
                    
               }
           }
        }
    }
    func view() -> UIView {
        return iosView
    }
    
    
    func layoutItems(_ adView: UIView, _ unifiedAd: BeiZiUnifiedNative, _ model: FlutterUnifiedParam){
                
        let ad = unifiedAd.dataObject
        
        if ad.isVideoAd {
            
        } else if ad.imageUrls.count > 1 {
            for i in 0..<ad.imageUrls.count {
                let width = (adView.frame.width - 10 * CGFloat(ad.imageUrls.count - 1)) / CGFloat(ad.imageUrls.count)
                let imgView = UIImageView(frame: CGRect(
                    x: 10 + CGFloat(i) * width,
                    y: 10,
                    width: width,
                    height: 150
                ))
                imgView.contentMode = .scaleAspectFit
                if let urlString = ad.imageUrls[i] as? String, let _ = URL(string: urlString) {
                    Tools.fetchImageData(from: urlString) { [weak imgView] result in
                        if case let .success(data) = result {
                            imgView?.image = UIImage(data: data)
                        }
                    }
                   
                }
                adView.addSubview(imgView)
            }
        } else if !ad.imageUrl.isEmpty {
            let imageUrl = ad.imageUrl
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: adView.frame.size.width, height: 150))
            if let imgModel = model.unifiedWidget?.children?.first(where: { child in
                child.type == .mainImage
            }){
                imageView.frame = CGRect(x: imgModel.x ?? 0, y: imgModel.y ?? 0, width: imgModel.width ??  adView.frame.size.width, height: imgModel.height ?? adView.frame.size.height)
                if let bgColor = imgModel.backgroundColor{
                    imageView.backgroundColor = UIColor(hexString: bgColor)
                }
                
            }
            imageView.contentMode = .scaleAspectFit
            if let _ = URL(string: imageUrl) {
                Tools.fetchImageData(from: imageUrl) { [weak imageView] result in
                    if case let .success(data) = result {
                        imageView?.image = UIImage(data: data)
                    }
                }
            }
            
            adView.addSubview(imageView)
                             
        }

        // 设置广告Logo
        let adLogoImageView = UIImageView(frame: CGRect(x: adView.frame.width - 50, y: adView.frame.width - 20, width: 36, height: 14))
        adLogoImageView.contentMode = .scaleAspectFit
        if let imgModel = model.unifiedWidget?.children?.first(where: { child in
            child.type == .adSourceLogo
        }){
           adLogoImageView.frame = CGRect(x: imgModel.x ?? adView.frame.width - 50, y: imgModel.y ?? adView.frame.width - 20, width: imgModel.width ?? 36, height: imgModel.height ?? 14)
        }
        if !ad.adLogoUrl.isEmpty {
            let adLogoUrl = ad.adLogoUrl
            if let _ = URL(string: adLogoUrl) {
                adView.addSubview(adLogoImageView)
                Tools.fetchImageData(from: adLogoUrl) { [weak adLogoImageView] result in
                    if case let .success(data) = result {
                        adLogoImageView?.image = UIImage(data: data)
                    }
                }
            }
        }

        // 创建图标iconImageView
        let iconImageView = UIImageView()
        if  !ad.iconUrl.isEmpty {
            let iconUrl = ad.iconUrl
            iconImageView.frame = CGRect(x: 5, y: 165, width: 65, height: 65)
            iconImageView.contentMode = .scaleAspectFit
            if let _ = URL(string: iconUrl) {
                adView.addSubview(iconImageView)
                Tools.fetchImageData(from: iconUrl) { [weak iconImageView] result in
                    if case let .success(data) = result {
                        iconImageView?.image = UIImage(data: data)
                    }
                }
            }
        }
        if let imgModel = model.unifiedWidget?.children?.first(where: { child in
            child.type == .appIcon
        }){
            iconImageView.frame = CGRectMake(imgModel.x ?? 0, imgModel.y ?? 0, imgModel.width ?? 0, imgModel.height ?? 0)
        }

        // 创建标题Label
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(
            x: iconImageView.frame.width + 10,
            y: 165,
            width: adView.frame.width - 85,
            height: 30
        )
        titleLabel.text = ad.title
        titleLabel.textColor = .darkGray
        if let imgModel = model.unifiedWidget?.children?.first(where: { child in
            child.type == .mainTitle
        }){
            titleLabel.frame = CGRectMake(imgModel.x ?? 0, imgModel.y ?? 0, adView.frame.width - 40, imgModel.height ?? 20)
            if let bgColor = imgModel.backgroundColor {
                titleLabel.backgroundColor = UIColor(hexString: bgColor)
            }
            if let fontSize = imgModel.fontSize {
                titleLabel.font = UIFont.systemFont(ofSize: fontSize)
            }
            if let color = imgModel.color {
                titleLabel.textColor = UIColor(hexString: color)
            }
        }
        
        // 创建描述Label
        let descLabel = UILabel()
        descLabel.frame = CGRect(
            x: iconImageView.frame.width + 10,
            y: 200,
            width: adView.frame.width - 85,
            height: 30
        )
        descLabel.text = ad.desc
        descLabel.font = .systemFont(ofSize: 21.0)
        descLabel.textColor = .gray
        
        if let imgModel = model.unifiedWidget?.children?.first(where: { child in
            child.type == .descText
        }){
            descLabel.frame = CGRectMake(imgModel.x ?? 0, imgModel.y ?? 0, imgModel.width ?? adView.frame.width - 40, imgModel.height ?? 30)
            if let bgColor = imgModel.backgroundColor {
                descLabel.backgroundColor = UIColor(hexString: bgColor)
            }
            if let fontSize = imgModel.fontSize {
                descLabel.font = UIFont.systemFont(ofSize: fontSize)
            }
            if let color = imgModel.color {
                descLabel.textColor = UIColor(hexString: color)
            }
        }
        // 添加子视图
        adView.addSubview(titleLabel)
        adView.addSubview(descLabel)
        
        unifiedAd.registerContainer(self.iosView, clickableViews: [adView])
        adView.frame = self.iosView.frame
        
    }
    
}


struct FlutterUnifiedParam:Codable {
    var adId: String?
    var unifiedWidget: FlutterUnifiedWidget?
}

struct FlutterUnifiedWidget:Codable {
    var children: [FlutterUnifiedChild]? = []
    var backgroundColor: String?
    var type: String?
    var width: CGFloat?
    var height: CGFloat?
}

struct FlutterUnifiedChild: Codable {
    var x: CGFloat?
    var y: CGFloat?
    var width: CGFloat?
    var height: CGFloat?
    var clickIdType: Int?
    var clickType: Int?
    var backgroundColor: String?
    
    var type: FlutterUnifiedChildType?
    var imagePath: String?
    var fontSize: CGFloat?
    var color: String?
    var bttonType: String?
    var fontColor: String?
    var content: String?
    
    
    
    
}

enum FlutterUnifiedChildType:String,Codable {
    case mainImage //= "mainImage"
    case mainTitle //= "mainTitle"
    case descText
    case actionButton
    case adSourceLogo
    case appIcon
    case downloadInfo
    case video
    case closeIcon
    
}
