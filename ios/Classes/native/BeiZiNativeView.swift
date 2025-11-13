//
//  BeiZiNativeView.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/13.
//

import Foundation
import Flutter

class BZNAtiveViewFactory: NSObject,FlutterPlatformViewFactory {
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> any FlutterPlatformView {
        return BZNativeView(frame: frame, viewId: viewId, args: args)
    }
    
    func createArgsCodec() -> any FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    
}

class BZNativeView : NSObject, FlutterPlatformView {
    
    private var iosView: UIView
    init(frame: CGRect,viewId: Int64,args:Any?) {
        self.iosView = UIView(frame: frame)
        
        if let param = args as? [String: Any?]{
           if let adId = param["native_adId"] as? String {
               if let adView = BeiZiNativeManager.getInstance().getAdView(adId) {
                   if let width = param["width"] as? CGFloat {
                       adView.bounds.size.width = width
                       self.iosView.frame.size.width = UIScreen.main.bounds.width
                       adView.frame.origin.x =  (self.iosView.frame.size.width - width)/2
                    
                   }
                   self.iosView.clipsToBounds = true
                   self.iosView.addSubview(adView)
               }
           }
        }
    }
    func view() -> UIView {
        return iosView
    }
}
