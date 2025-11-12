package com.beizi.beizi_sdk.data

object BeiZiPlatformViewRegistry {
    private const val CHANNEL_DOMAIN = "com.beizi.sdk"
    const val BeiZi_SDK_NATIVE_VIEW_ID = "$CHANNEL_DOMAIN/native_view_id"
    const val BeiZi_SDK_NATIVE_UNIFIED_VIEW_ID = "$CHANNEL_DOMAIN/native_unified_view_id"

}

object BeiZiInitChannelMethod {
    const val INIT_SUCCESS = "initSuccess"
    const val INITIALIZING = "initializing"
    const val ALREADY_INIT = "alreadyInit"
    const val INIT_FAILED = "initFailed"
}

object BeiZiAdCallBackChannelMethod {
    /// 广告加载成功
    const val ON_AD_LOADED = "onAdLoaded";

    /// 广告展示成功
    const val ON_AD_SHOWN = "onAdShown";

    /// 广告加载失败
    const val ON_AD_FAILED_TO_LOAD = "onAdFailedToLoad";

    /// 广告关闭 (开屏广告结束/用户跳过)
    const val ON_AD_CLOSED = "onAdClosed";

    /// 广告倒计时/进度更新
    const val ON_AD_TICK = "onAdTick";

    /// 广告被点击
    const val ON_AD_CLICKED = "onAdClicked";
}

object BeiZiInterAdCallBackMethod {
    /// 广告加载成功
    const val ON_AD_LOADED = "Inter_onAdLoaded";

    /// 广告展示成功
    const val ON_AD_SHOWN = "Inter_onAdShown";

    /// 广告加载失败
    const val ON_AD_FAILED = "Inter_onAdFailed";

    /// 广告关闭 (开屏广告结束/用户跳过)
    const val ON_AD_CLOSED = "Inter_onAdClosed";

    /// 广告被点击
    const val ON_AD_CLICKED = "Inter_onAdClicked";
}

/// 激励视频广告相关方法
object BeiZiRewardedVideoAdChannelMethod {
    /// 广告激励发放
    const val ON_REWARDED = "Reward_onRewarded"
    /// 广告加载失败
    const val ON_REWARDED_VIDEO_AD_FAILED_TO_LOAD = "Reward_onAdFailedToLoad"
    /// 广告加载成功
    const val ON_REWARDED_VIDEO_AD_LOADED = "Reward_onAdLoaded"
    /// 广告缓存成功
    const val ON_REWARDED_VIDEO_CACHE_SUCCESS = "Reward_onCacheSuccess"
    /// 广告展示成功
    const val ON_REWARDED_VIDEO_AD_SHOWN = "Reward_onAdShown"
    /// 广告关闭
    const val ON_REWARDED_VIDEO_AD_CLOSED = "Reward_onAdClosed"
    /// 广告被点击
    const val ON_REWARDED_VIDEO_CLICK = "Reward_onAdClicked"
    /// 广告播放完成
    const val ON_REWARDED_VIDEO_COMPLETE = "Reward_onAdComplete"
    /// 广告播放错误
    const val ON_REWARDED_VIDEO_PLAY_ERROR = "Reward_onPlayError"
}

object BeiZiNativeAdChannelMethod {
    const val ON_AD_FAILED = "Native_onAdFailed"
    const val ON_AD_LOADED = "Native_onAdLoaded"
    const val ON_AD_SHOWN = "Native_onAdShown"
    const val ON_AD_CLOSED = "Native_onAdClosed"
    const val ON_AD_CLOSED_VIEW = "Native_onAdClosedView"
    const val ON_AD_CLICK = "Native_onAdClick"
}

object BeiZiNativeUnifiedAdChannelMethod {
    const val ON_AD_FAILED = "Native_Unified_onAdFailed"
    const val ON_AD_LOADED = "Native_Unified_onAdLoaded"
    const val ON_AD_SHOWN = "Native_Unified_onAdShown"
    const val ON_AD_CLOSED = "Native_Unified_onAdClosed"
    const val ON_AD_CLICK = "Native_Unified_onAdClick"
}

object BeiZiSdkMethodNames {
    // Method name for initializing BeiZi Ad SDK
    const val INIT = "BeiZiSdk_init"

    // Splash ad related methods
    const val SPLASH_CREATE = "BeiZiSplashAd_create";
    const val SPLASH_LOAD = "BeiZiSplashAd_load"
    const val SPLASH_SHOW_AD = "BeiZiSplashAd_showAd"
    const val SPLASH_GET_ECPM = "BeiZiSplashAd_getECPM"
    const val SPLASH_NOTIFY_RTB_WIN = "BeiZiSplashAd_notifyRTBWin"
    const val SPLASH_NOTIFY_RTB_LOSS = "BeiZiSplashAd_notifyRTBLoss"
    const val SPLASH_GET_CUSTOM_EXT_DATA = "BeiZiSplashAd_getCustomExtData"
    const val SPLASH_GET_CUSTOM_JSON_DATA = "BeiZiSplashAd_getCustomJsonData"
    const val SPLASH_SET_BID_RESPONSE = "BeiZiSplashAd_setBidResponse"
    const val SPLASH_SET_SPACE_PARAM = "BeiZiSplashAd_setSpaceParam"
    const val SPLASH_CANCEL = "BeiZiSplashAd_Cancel"

    // Interstitial ad related methods
    const val INTERSTITIAL_CREATE = "BeiZiInterstitial_create"
    const val INTERSTITIAL_LOAD = "BeiZiInterstitial_load"
    const val INTERSTITIAL_SET_AD_VERSION = "BeiZiInterstitial_setAdVersion"
    const val INTERSTITIAL_SHOW_AD = "BeiZiSInterstitial_showAd"
    const val INTERSTITIAL_IS_LOADED = "BeiZiSInterstitial_isLoaded";
    const val INTERSTITIAL_GET_ECPM = "BeiZiSInterstitial_getECPM"
    const val INTERSTITIAL_NOTIFY_RTB_WIN = "BeiZiInterstitial_notifyRTBWin"
    const val INTERSTITIAL_NOTIFY_RTB_LOSS = "BeiZiInterstitial_notifyRTBLoss"
    const val INTERSTITIAL_GET_CUSTOM_EXT_DATA = "BeiZiInterstitial_getCustomExtData"
    const val INTERSTITIAL_GET_CUSTOM_JSON_DATA = "BeiZiInterstitial_getCustomJsonData"
    const val INTERSTITIAL_SET_BID_RESPONSE = "BeiZiInterstitial_setBidResponse"
    const val INTERSTITIAL_SET_SPACE_PARAM = "BeiZiInterstitial_setSpaceParam"
    const val INTERSTITIAL_DESTROY = "BeiZiInterstitial_Destroy"

    //RewardedVideo ad related methods
    const val REWARDED_VIDEO_CREATE = "BeiZiRewardedVideo_create"
    const val REWARDED_VIDEO_LOAD = "BeiZiRewardedVideo_load"
    const val REWARDED_VIDEO_SHOW_AD = "BeiZiSRewardedVideo_showAd"
    const val REWARDED_VIDEO_IS_LOADED = "BeiZiSRewardedVideo_isLoaded"
    const val REWARDED_VIDEO_GET_USERID = "BeiZiSRewardedVideo_getUserId"
    const val REWARDED_VIDEO_SET_USERID = "BeiZiSRewardedVideo_setUserId"
    const val REWARDED_VIDEO_GET_ECPM = "BeiZiSRewardedVideo_getECPM"
    const val REWARDED_VIDEO_NOTIFY_RTB_WIN = "BeiZiRewardedVideo_notifyRTBWin"
    const val REWARDED_VIDEO_NOTIFY_RTB_LOSS = "BeiZiRewardedVideo_notifyRTBLoss"
    const val REWARDED_VIDEO_GET_EXTRA = "BeiZiRewardedVideo_getExtra"
    const val REWARDED_VIDEO_SET_EXTRA = "BeiZiRewardedVideo_setExtra"
    const val REWARDED_VIDEO_GET_CUSTOM_EXT_DATA = "BeiZiRewardedVideo_getCustomExtData"
    const val REWARDED_VIDEO_GET_CUSTOM_JSON_DATA = "BeiZiRewardedVideo_getCustomJsonData"
    const val REWARDED_VIDEO_SET_BID_RESPONSE = "BeiZiRewardedVideo_setBidResponse"
    const val REWARDED_VIDEO_SET_SPACE_PARAM = "BeiZiRewardedVideo_setSpaceParam"
    const val REWARDED_VIDEO_DESTROY = "BeiZiRewardedVideo_Destroy"

    // Native ad related methods
    const val NATIVE_CREATE = "BeiZiNative_create"
    const val NATIVE_LOAD = "BeiZiNative_load"
    const val NATIVE_RESUME = "BeiZiNative_resume"
    const val NATIVE_PAUSE = "BeiZiNative_pause"
    const val NATIVE_GET_ECPM = "BeiZiNative_getECPM"
    const val NATIVE_DESTROY = "BeiZiNative_destroy"
    const val NATIVE_GET_CUSTOM_EXT_DATA = "BeiZiNative_getCustomExtData"
    const val NATIVE_GET_CUSTOM_JSON_DATA = "BeiZiNative_getCustomJsonData"
    const val NATIVE_NOTIFY_RTB_WIN = "BeiZiNative_notifyRTBWin"
    const val NATIVE_NOTIFY_RTB_LOSS = "BeiZiNative_notifyRTBLoss"
    const val NATIVE_SET_BID_RESPONSE = "BeiZiNative_setBidResponse"
    const val NATIVE_SET_SPACE_PARAM = "BeiZiNative_setSpaceParam"

    // Native Unified ad related methods
    const val NATIVE_UNIFIED_CREATE = "BeiZiNativeUnified_create"
    const val NATIVE_UNIFIED_SET_HIDE = "BeiZiNativeUnified_setHide"
    const val NATIVE_UNIFIED_GET_DOWNLOAD = "BeiZiNativeUnified_getDownLoad"
    const val NATIVE_UNIFIED_LOAD = "BeiZiNativeUnified_load"
    const val NATIVE_UNIFIED_RESUME = "BeiZiNativeUnified_resume"
    const val NATIVE_UNIFIED_GET_ECPM = "BeiZiNativeUnified_getECPM"
    const val NATIVE_UNIFIED_DESTROY = "BeiZiNativeUnified_destroy"
    const val NATIVE_UNIFIED_GET_CUSTOM_EXT_DATA = "BeiZiNativeUnified_getCustomExtData"
    const val NATIVE_UNIFIED_GET_CUSTOM_JSON_DATA = "BeiZiNativeUnified_getCustomJsonData"
    const val NATIVE_UNIFIED_NOTIFY_RTB_WIN = "BeiZiNativeUnified_notifyRTBWin"
    const val NATIVE_UNIFIED_NOTIFY_RTB_LOSS = "BeiZiNativeUnified_notifyRTBLoss"
    const val NATIVE_UNIFIED_SET_BID_RESPONSE = "BeiZiNativeUnified_setBidResponse"
    const val NATIVE_UNIFIED_SET_SPACE_PARAM = "BeiZiNativeUnified_setSpaceParam"
}

object BeiZiSplashKeys {
    const val WIDTH = "width"
    const val HEIGHT = "height"
    const val BOTTOM_WIDGET = "bottomWidget"
    const val AD_SPACE_ID = "adSpaceId"
    const val TOTAL_TIME = "totalTime"
}

object BeiZiInterKeys {
    const val AD_SPACE_ID = "adSpaceId"
    const val TOTAL_TIME = "totalTime"
    const val MODEL_TYPE = "modelType"
}

object BeiZiRewardVideoKeys {
    const val AD_SPACE_ID = "adSpaceId"
    const val TOTAL_TIME = "totalTime"
    const val MODEL_TYPE = "modelType"
}

object BeiZiNativeKeys {
    const val WIDTH = "width"
    const val HEIGHT = "height"
    const val AD_SPACE_ID = "adSpaceId"
    const val TOTAL_TIME = "totalTime"
    const val AD_ID = "native_adId"
    const val MODEL_TYPE = "modelType"
}

object BeiZiNativeUnifiedKeys {
    const val WIDTH = "width"
    const val HEIGHT = "height"
    const val AD_SPACE_ID = "adSpaceId"
    const val TOTAL_TIME = "totalTime"
    const val AD_ID = "adId"
    const val MODEL_TYPE = "modelType"
    const val HIDE_AD_LOGO = "HideAdLogo"
    const val HIDE_DOWNLOAD_INFO = "HideDownloadInfo"
}

val InitMethodNames: Set<String> = setOf(
    BeiZiSdkMethodNames.INIT
)

val SplashMethodNames: Set<String> = setOf(
    BeiZiSdkMethodNames.SPLASH_CREATE,
    BeiZiSdkMethodNames.SPLASH_LOAD,
    BeiZiSdkMethodNames.SPLASH_SHOW_AD,
    BeiZiSdkMethodNames.SPLASH_GET_ECPM,
    BeiZiSdkMethodNames.SPLASH_NOTIFY_RTB_WIN,
    BeiZiSdkMethodNames.SPLASH_NOTIFY_RTB_LOSS,
    BeiZiSdkMethodNames.SPLASH_GET_CUSTOM_EXT_DATA,
    BeiZiSdkMethodNames.SPLASH_GET_CUSTOM_JSON_DATA,
    BeiZiSdkMethodNames.SPLASH_SET_BID_RESPONSE,
    BeiZiSdkMethodNames.SPLASH_SET_SPACE_PARAM,
    BeiZiSdkMethodNames.SPLASH_CANCEL
)

val InterstitialMethodNames: Set<String> = setOf(
    BeiZiSdkMethodNames.INTERSTITIAL_CREATE,
    BeiZiSdkMethodNames.INTERSTITIAL_LOAD,
    BeiZiSdkMethodNames.INTERSTITIAL_SHOW_AD,
    BeiZiSdkMethodNames.INTERSTITIAL_IS_LOADED,
    BeiZiSdkMethodNames.INTERSTITIAL_GET_ECPM,
    BeiZiSdkMethodNames.INTERSTITIAL_NOTIFY_RTB_WIN,
    BeiZiSdkMethodNames.INTERSTITIAL_NOTIFY_RTB_LOSS,
    BeiZiSdkMethodNames.INTERSTITIAL_GET_CUSTOM_EXT_DATA,
    BeiZiSdkMethodNames.INTERSTITIAL_GET_CUSTOM_JSON_DATA,
    BeiZiSdkMethodNames.INTERSTITIAL_SET_BID_RESPONSE,
    BeiZiSdkMethodNames.INTERSTITIAL_SET_SPACE_PARAM,
    BeiZiSdkMethodNames.INTERSTITIAL_DESTROY
)

// 激励视频广告相关方法名集合
val RewardedVideoAdMethodNames: Set<String> = setOf(
    BeiZiSdkMethodNames.REWARDED_VIDEO_CREATE,
    BeiZiSdkMethodNames.REWARDED_VIDEO_LOAD,
    BeiZiSdkMethodNames.REWARDED_VIDEO_SHOW_AD,
    BeiZiSdkMethodNames.REWARDED_VIDEO_IS_LOADED,
    BeiZiSdkMethodNames.REWARDED_VIDEO_GET_USERID,
    BeiZiSdkMethodNames.REWARDED_VIDEO_SET_USERID,
    BeiZiSdkMethodNames.REWARDED_VIDEO_GET_ECPM,
    BeiZiSdkMethodNames.REWARDED_VIDEO_NOTIFY_RTB_WIN,
    BeiZiSdkMethodNames.REWARDED_VIDEO_NOTIFY_RTB_LOSS,
    BeiZiSdkMethodNames.REWARDED_VIDEO_GET_EXTRA,
    BeiZiSdkMethodNames.REWARDED_VIDEO_SET_EXTRA,
    BeiZiSdkMethodNames.REWARDED_VIDEO_GET_CUSTOM_EXT_DATA,
    BeiZiSdkMethodNames.REWARDED_VIDEO_GET_CUSTOM_JSON_DATA,
    BeiZiSdkMethodNames.REWARDED_VIDEO_SET_BID_RESPONSE,
    BeiZiSdkMethodNames.REWARDED_VIDEO_SET_SPACE_PARAM,
    BeiZiSdkMethodNames.REWARDED_VIDEO_DESTROY
)

val NativeMethodNames: Set<String> = setOf(
    BeiZiSdkMethodNames.NATIVE_CREATE,
    BeiZiSdkMethodNames.NATIVE_LOAD,
    BeiZiSdkMethodNames.NATIVE_RESUME,
    BeiZiSdkMethodNames.NATIVE_PAUSE,
    BeiZiSdkMethodNames.NATIVE_GET_ECPM,
    BeiZiSdkMethodNames.NATIVE_DESTROY,
    BeiZiSdkMethodNames.NATIVE_GET_CUSTOM_EXT_DATA,
    BeiZiSdkMethodNames.NATIVE_GET_CUSTOM_JSON_DATA,
    BeiZiSdkMethodNames.NATIVE_NOTIFY_RTB_WIN,
    BeiZiSdkMethodNames.NATIVE_NOTIFY_RTB_LOSS,
    BeiZiSdkMethodNames.NATIVE_SET_BID_RESPONSE,
    BeiZiSdkMethodNames.NATIVE_SET_SPACE_PARAM
)

val NativeUnifiedMethodNames: Set<String> = setOf(
    BeiZiSdkMethodNames.NATIVE_UNIFIED_CREATE,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_SET_HIDE,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_GET_DOWNLOAD,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_LOAD,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_RESUME,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_GET_ECPM,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_DESTROY,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_GET_CUSTOM_EXT_DATA,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_GET_CUSTOM_JSON_DATA,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_NOTIFY_RTB_WIN,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_NOTIFY_RTB_LOSS,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_SET_BID_RESPONSE,
    BeiZiSdkMethodNames.NATIVE_UNIFIED_SET_SPACE_PARAM
)

