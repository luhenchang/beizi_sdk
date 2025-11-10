//
//  BeiziInitKeys.swift
//  beizi_sdk
//
//  Created by duzhaoquan on 2025/11/10.
//

import Foundation

enum BeiziInitKeys {
    // 应用ID
    static let appId = "appId"
    
    // 个性化推荐
    static let isPersonalRecommend = "isPersonalRecommend"
    
    // 位置相关
    static let canUseLocation = "canUseLocation"
    static let location = "location"
    static let longitude = "longitude"
    static let latitude = "latitude"
    static let type = "type"
    
    /// 位置修复的时间戳（自纪元以来的毫秒数），对应 `getTime()`
    static let time = "time"
    
    // WiFi状态相关
    static let canUseWifiState = "canUseWifiState"
    
    // 电话状态相关
    static let canUsePhoneState = "canUsePhoneState"
    
    // OAID相关
    static let canUseOaid = "canUseOaid"
    static let devOaid = "devOaid"
    static let oaidVersion = "oaidVersion"
    
    // GAID相关
    static let canUseGaid = "canUseGaid"
    
    // 应用列表相关
    static let canUseAppList = "canUseAppList"
    
    // 传感器相关
    static let shouldForbidSensor = "shouldForbidSensor"
    
    // Android ID相关
    static let canUseAndroidId = "canUseAndroidId"
    static let androidId = "androidId"
}
