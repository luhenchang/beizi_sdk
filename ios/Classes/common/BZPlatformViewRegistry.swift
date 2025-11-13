//
//  BZPlatformViewRegistry.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/13.
//

import Foundation
import Flutter


class BZPlatformViewRegistry {
    
    private static var instance: BZPlatformViewRegistry?
    static func getInstance() -> BZPlatformViewRegistry{
        if BZPlatformViewRegistry.instance == nil {
            BZPlatformViewRegistry.instance = .init()
        }
        return BZPlatformViewRegistry.instance!
    }
    private init() {}
    
    
    func regist(_ binding: FlutterPluginRegistrar){
        
        binding.register(BZNAtiveViewFactory(), withId: BeiZiPlatformViewIds.beiZiSDKNativeViewId)
        //
        //    binding.register(AMPSUnifiedNAtiveViewFactory(), withId: AMPSPlatformViewIds.unifiedViewId)
        //
    }
}
