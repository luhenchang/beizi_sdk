//
//  BZPlatformViewRegistry.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/13.
//

import Foundation
import Flutter


class BZPlatformViewRegistry {
    
    static let shared: BZPlatformViewRegistry = .init()
    private init() {}
    
    
    
    //注册视图
    func regist(_ binding: FlutterPluginRegistrar){
        
        binding.register(BZNAtiveViewFactory(), withId: BeiZiPlatformViewIds.beiZiSDKNativeViewId)
        binding.register(BeiZiUnifiedNAtiveViewFactory(), withId: BeiZiPlatformViewIds.beiZiSdkUnifiedViewId)
        
    }
}
