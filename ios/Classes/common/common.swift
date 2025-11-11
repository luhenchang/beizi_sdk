//
//  common.swift
//  beizi_sdk
//
//  Created by duzhaoquan on 2025/11/10.
//

import Foundation

// 平台视图注册相关常量
enum BeiZiPlatformViewRegistry {
    private static let channelDomain = "com.beizi.sdk"
    static let beiZiSDKNativeViewId = "\(channelDomain)/native_view_id"
}

// 初始化相关回调方法名
enum BeiZiInitChannelMethod {
    static let initSuccess = "initSuccess"
    static let initializing = "initializing"
    static let alreadyInit = "alreadyInit"
    static let initFailed = "initFailed"
}

// 广告通用回调方法名
enum BeiZiAdCallBackChannelMethod {
    /// 广告加载成功
    static let onAdLoaded = "onAdLoaded"
    /// 广告展示成功
    static let onAdShown = "onAdShown"
    /// 广告加载失败
    static let onAdFailedToLoad = "onAdFailedToLoad"
    /// 广告关闭 (开屏广告结束/用户跳过)
    static let onAdClosed = "onAdClosed"
    /// 广告倒计时/进度更新
    static let onAdTick = "onAdTick"
    /// 广告被点击
    static let onAdClicked = "onAdClicked"
}

// 插屏广告回调方法名
enum BeiZiInterAdCallBackMethod {
    /// 广告加载成功
    static let onAdLoaded = "Inter_onAdLoaded"
    /// 广告展示成功
    static let onAdShown = "Inter_onAdShown"
    /// 广告加载失败
    static let onAdFailed = "Inter_onAdFailed"
    /// 广告关闭
    static let onAdClosed = "Inter_onAdClosed"
    /// 广告被点击
    static let onAdClicked = "Inter_onAdClicked"
}

// 激励视频广告回调方法名
enum BeiZiRewardedVideoAdChannelMethod {
    /// 广告激励发放
    static let onRewarded = "Reward_onRewarded"
    /// 广告加载失败
    static let onRewardedVideoAdFailedToLoad = "Reward_onAdFailedToLoad"
    /// 广告加载成功
    static let onRewardedVideoAdLoaded = "Reward_onAdLoaded"
    /// 广告缓存成功
    static let onRewardedVideoCacheSuccess = "Reward_onCacheSuccess"
    /// 广告展示成功
    static let onRewardedVideoAdShown = "Reward_onAdShown"
    /// 广告关闭
    static let onRewardedVideoAdClosed = "Reward_onAdClosed"
    /// 广告被点击
    static let onRewardedVideoClick = "Reward_onAdClicked"
    /// 广告播放完成
    static let onRewardedVideoComplete = "Reward_onAdComplete"
    /// 广告播放错误
    static let onRewardedVideoPlayError = "Reward_onPlayError"
}

// 原生广告回调方法名
enum BeiZiNativeAdChannelMethod {
    static let onAdFailed = "Native_onAdFailed"
    static let onAdLoaded = "Native_onAdLoaded"
    static let onAdShown = "Native_onAdShown"
    static let onAdClosed = "Native_onAdClosed"
    static let onAdClosedView = "Native_onAdClosedView"
    static let onAdClick = "Native_onAdClick"
}

// SDK方法名集合
enum BeiZiSdkMethodNames {
    // SDK初始化方法
    static let initSDK = "BeiZiSdk_init"
    
    // 开屏广告相关方法
    static let splashCreate = "BeiZiSplashAd_create"
    static let splashLoad = "BeiZiSplashAd_load"
    static let splashShowAd = "BeiZiSplashAd_showAd"
    static let splashGetEcpm = "BeiZiSplashAd_getECPM"
    static let splashNotifyRtbWin = "BeiZiSplashAd_notifyRTBWin"
    static let splashNotifyRtbLoss = "BeiZiSplashAd_notifyRTBLoss"
    static let splashGetCustomParam = "BeiZiSplashAd_GetCustomParam"
    static let splashGetAnyParam = "BeiZiSplashAd_GetAnyParam"
    static let splashSetBidResponse = "BeiZiSplashAd_setBidResponse"
    static let splashSetSpaceParam = "BeiZiSplashAd_setSpaceParam"
    static let splashCancel = "BeiZiSplashAd_Cancel"
    
    // 插屏广告相关方法
    static let interstitialCreate = "BeiZiInterstitial_create"
    static let interstitialLoad = "BeiZiInterstitial_load"
    static let interstitialSetAdVersion = "BeiZiInterstitial_setAdVersion"
    static let interstitialShowAd = "BeiZiSInterstitial_showAd"
    static let interstitialIsLoaded = "BeiZiSInterstitial_isLoaded"
    static let interstitialGetEcpm = "BeiZiSInterstitial_getECPM"
    static let interstitialNotifyRtbWin = "BeiZiInterstitial_notifyRTBWin"
    static let interstitialNotifyRtbLoss = "BeiZiInterstitial_notifyRTBLoss"
    static let interstitialGetCustomExtData = "BeiZiInterstitial_getCustomExtData"
    static let interstitialGetCustomJsonData = "BeiZiInterstitial_getCustomJsonData"
    static let interstitialSetBidResponse = "BeiZiInterstitial_setBidResponse"
    static let interstitialSetSpaceParam = "BeiZiInterstitial_setSpaceParam"
    static let interstitialDestroy = "BeiZiInterstitial_Destroy"
    
    // 激励视频广告相关方法
    static let rewardedVideoCreate = "BeiZiRewardedVideo_create"
    static let rewardedVideoLoad = "BeiZiRewardedVideo_load"
    static let rewardedVideoShowAd = "BeiZiSRewardedVideo_showAd"
    static let rewardedVideoIsLoaded = "BeiZiSRewardedVideo_isLoaded"
    static let rewardedVideoGetUserId = "BeiZiSRewardedVideo_getUserId"
    static let rewardedVideoSetUserId = "BeiZiSRewardedVideo_setUserId"
    static let rewardedVideoGetEcpm = "BeiZiSRewardedVideo_getECPM"
    static let rewardedVideoNotifyRtbWin = "BeiZiRewardedVideo_notifyRTBWin"
    static let rewardedVideoNotifyRtbLoss = "BeiZiRewardedVideo_notifyRTBLoss"
    static let rewardedVideoGetExtra = "BeiZiRewardedVideo_getExtra"
    static let rewardedVideoSetExtra = "BeiZiRewardedVideo_setExtra"
    static let rewardedVideoGetCustomExtData = "BeiZiRewardedVideo_getCustomExtData"
    static let rewardedVideoGetCustomJsonData = "BeiZiRewardedVideo_getCustomJsonData"
    static let rewardedVideoSetBidResponse = "BeiZiRewardedVideo_setBidResponse"
    static let rewardedVideoSetSpaceParam = "BeiZiRewardedVideo_setSpaceParam"
    static let rewardedVideoDestroy = "BeiZiRewardedVideo_Destroy"
    
    // 原生广告相关方法
    static let nativeCreate = "BeiZiNative_create"
    static let nativeLoad = "BeiZiNative_load"
    static let nativeResume = "BeiZiNative_resume"
    static let nativePause = "BeiZiNative_pause"
    static let nativeGetEcpm = "BeiZiNative_getECPM"
    static let nativeDestroy = "BeiZiNative_destroy"
    static let nativeGetCustomExtData = "BeiZiNative_getCustomExtData"
    static let nativeGetCustomJsonData = "BeiZiNative_getCustomJsonData"
    static let nativeNotifyRtbWin = "BeiZiNative_notifyRTBWin"
    static let nativeNotifyRtbLoss = "BeiZiNative_notifyRTBLoss"
    static let nativeSetBidResponse = "BeiZiNative_setBidResponse"
    static let nativeSetSpaceParam = "BeiZiNative_setSpaceParam"
}

// 开屏广告参数键名
enum BeiZiSplashKeys {
    static let width = "width"
    static let height = "height"
    static let adSpaceId = "adSpaceId"
    static let totalTime = "totalTime"
}

// 插屏广告参数键名
enum BeiZiInterKeys {
    static let adSpaceId = "adSpaceId"
    static let totalTime = "totalTime"
    static let modelType = "modelType"
}

// 激励视频广告参数键名
enum BeiZiRewardVideoKeys {
    static let adSpaceId = "adSpaceId"
    static let totalTime = "totalTime"
    static let modelType = "modelType"
}

// 原生广告参数键名
enum BeiZiNativeKeys {
    static let width = "width"
    static let height = "height"
    static let adSpaceId = "adSpaceId"
    static let totalTime = "totalTime"
    static let adId = "native_adId"
    static let modelType = "modelType"
}

// 方法名集合（对应原Kotlin的Set）
let initMethodNames: Set<String> = [
    BeiZiSdkMethodNames.initSDK
]

let splashMethodNames: Set<String> = [
    BeiZiSdkMethodNames.splashCreate,
    BeiZiSdkMethodNames.splashLoad,
    BeiZiSdkMethodNames.splashShowAd,
    BeiZiSdkMethodNames.splashGetEcpm,
    BeiZiSdkMethodNames.splashNotifyRtbWin,
    BeiZiSdkMethodNames.splashNotifyRtbLoss,
    BeiZiSdkMethodNames.splashGetCustomParam,
    BeiZiSdkMethodNames.splashGetAnyParam,
    BeiZiSdkMethodNames.splashSetBidResponse,
    BeiZiSdkMethodNames.splashSetSpaceParam,
    BeiZiSdkMethodNames.splashCancel
]

let interstitialMethodNames: Set<String> = [
    BeiZiSdkMethodNames.interstitialCreate,
    BeiZiSdkMethodNames.interstitialLoad,
    BeiZiSdkMethodNames.interstitialShowAd,
    BeiZiSdkMethodNames.interstitialIsLoaded,
    BeiZiSdkMethodNames.interstitialGetEcpm,
    BeiZiSdkMethodNames.interstitialNotifyRtbWin,
    BeiZiSdkMethodNames.interstitialNotifyRtbLoss,
    BeiZiSdkMethodNames.interstitialGetCustomExtData,
    BeiZiSdkMethodNames.interstitialGetCustomJsonData,
    BeiZiSdkMethodNames.interstitialSetBidResponse,
    BeiZiSdkMethodNames.interstitialSetSpaceParam,
    BeiZiSdkMethodNames.interstitialDestroy
]

// 激励视频广告相关方法名集合
let rewardedVideoAdMethodNames: Set<String> = [
    BeiZiSdkMethodNames.rewardedVideoCreate,
    BeiZiSdkMethodNames.rewardedVideoLoad,
    BeiZiSdkMethodNames.rewardedVideoShowAd,
    BeiZiSdkMethodNames.rewardedVideoIsLoaded,
    BeiZiSdkMethodNames.rewardedVideoGetUserId,
    BeiZiSdkMethodNames.rewardedVideoSetUserId,
    BeiZiSdkMethodNames.rewardedVideoGetEcpm,
    BeiZiSdkMethodNames.rewardedVideoNotifyRtbWin,
    BeiZiSdkMethodNames.rewardedVideoNotifyRtbLoss,
    BeiZiSdkMethodNames.rewardedVideoGetExtra,
    BeiZiSdkMethodNames.rewardedVideoSetExtra,
    BeiZiSdkMethodNames.rewardedVideoGetCustomExtData,
    BeiZiSdkMethodNames.rewardedVideoGetCustomJsonData,
    BeiZiSdkMethodNames.rewardedVideoSetBidResponse,
    BeiZiSdkMethodNames.rewardedVideoSetSpaceParam,
    BeiZiSdkMethodNames.rewardedVideoDestroy
]

let nativeMethodNames: Set<String> = [
    BeiZiSdkMethodNames.nativeCreate,
    BeiZiSdkMethodNames.nativeLoad,
    BeiZiSdkMethodNames.nativeResume,
    BeiZiSdkMethodNames.nativePause,
    BeiZiSdkMethodNames.nativeGetEcpm,
    BeiZiSdkMethodNames.nativeDestroy,
    BeiZiSdkMethodNames.nativeGetCustomExtData,
    BeiZiSdkMethodNames.nativeGetCustomJsonData,
    BeiZiSdkMethodNames.nativeNotifyRtbWin,
    BeiZiSdkMethodNames.nativeNotifyRtbLoss,
    BeiZiSdkMethodNames.nativeSetBidResponse,
    BeiZiSdkMethodNames.nativeSetSpaceParam
]


enum ArgumentKeys {
    // 参数键或其他字符串值的常量
    static let adWinPrice = "winPrice"
    static let adSecPrice = "secPrice"
    static let adId = "adId"
    static let adLossReason = "lossReason"
    static let adOption = "AdOption"
    static let config = "config"
    static let splashBottom = "SplashBottomView"
    static let videoSound = "videoSoundEnable"
    static let videoPlayType = "videoAutoPlayType"
    static let videoLoopReplay = "videoLoopReplay"
}
enum BidKeys{
    static let winPrince = "AMPS_WIN_PRICE"
    static let winADNId = "AMPS_WIN_ADNID"
    static let lossSecondPrice = "AMPS_HIGHRST_LOSS_PRICE"
    static let lossReason = "AMPS_LOSS_REASON"
    static let expectPrice = "AMPS_EXPECT_PRICE"
}
