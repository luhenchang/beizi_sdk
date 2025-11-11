//
//  InitParamModel.swift
//  beizi_sdk
//
//  Created by dzq_bookPro on 2025/11/11.
//

import Foundation

struct InitParamModel:Codable {
    var appId: String
    var isPersonalRecommend: Bool?
    
    
    var canUseLocation: Bool?
    var location: Double?
    var longitude: Double?
    var latitude: Double?
    var type: String?
    var time: Double?
    
    
    // WiFi状态相关
    var canUseWifiState: Bool?
    
    var canUsePhoneState: Bool?
    
    
    // OAID相关
    var canUseOaid: Bool?
    var devOaid: String?
    var oaidVersion: String?
    
    // GAID相关
    var canUseGaid: Bool?
    
    // 应用列表相关
    var canUseAppList: Bool?
    
    // 传感器相关
    var shouldForbidSensor: Bool?
    

}
