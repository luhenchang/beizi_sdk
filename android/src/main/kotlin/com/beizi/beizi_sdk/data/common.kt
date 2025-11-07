package com.beizi.beizi_sdk.data

import com.beizi.fusion.RewardedVideoAd

object StringConstants {
    const val EMPTY_STRING = ""
}

data class AdOptions(val spaceId: String)

object BeiZiChannels {
    private const val CHANNEL_DOMAIN = "biz.beizi.adn"

    const val BeiZi_SDK_INIT = "$CHANNEL_DOMAIN/sdk"
    const val BeiZi_SDK_SPLASH = "$CHANNEL_DOMAIN/splash"
    const val BeiZi_SDK_SPLASH_AD_LOAD = "$CHANNEL_DOMAIN/splash_ad_load"
    const val BeiZi_SDK_INTERSTITIAL_AD_LOAD = "$CHANNEL_DOMAIN/interstitial_ad_load"
    const val BeiZi_SDK_NATIVE_AD_LOAD = "$CHANNEL_DOMAIN/native_ad_load"
}

object BBeiZiPlatformViewRegistry {
    private const val CHANNEL_DOMAIN = "biz.beizi.adn"

    const val BeiZi_SDK_SPLASH_VIEW_ID = "$CHANNEL_DOMAIN/splash_view_id"
    const val BeiZi_SDK_INTERSTITIAL_VIEW_ID = "$CHANNEL_DOMAIN/interstitial_view_id"
    const val BeiZi_SDK_NATIVE_VIEW_ID = "$CHANNEL_DOMAIN/native_view_id"
    const val BeiZi_SDK_UNIFIED_VIEW_ID = "$CHANNEL_DOMAIN/unified_view_id"
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

object BeiZiNativeCallBackChannelMethod {
    // Ad loading callback identifiers
    const val LOAD_OK = "loadOk"
    const val LOAD_FAIL = "loadFail"
    const val RENDER_SUCCESS = "renderSuccess"
    const val RENDER_FAILED = "renderFailed"

    // Specific ad component callbacks
    const val ON_AD_SHOW = "onAdShow"
    const val ON_AD_EXPOSURE = "onAdExposure"
    const val ON_AD_EXPOSURE_FAIL = "onAdExposureFail"
    const val ON_AD_CLICKED = "onAdClicked"
    const val ON_AD_CLOSED = "onAdClosed" // Ad closed

    // Video component callbacks
    const val ON_VIDEO_INIT = "onVideoInit"; // 视频初始化
    const val ON_VIDEO_LOADING = "onVideoLoading"; // 视频加载中正在
    const val ON_VIDEO_READY = "onVideoReady" // Video ready
    const val ON_VIDEO_LOADED = "onVideoLoaded"; // 视频加载完成
    const val ON_VIDEO_PLAY_START = "onVideoPlayStart" // Video playback started
    const val ON_VIDEO_PLAY_COMPLETE = "onVideoPlayComplete" // Video playback completed
    const val ON_VIDEO_PAUSE = "onVideoPause" // Video paused
    const val ON_VIDEO_RESUME = "onVideoResume" // Video resumed
    const val ON_VIDEO_STOP = "onVideoStop"; // 视频停止
    const val ON_VIDEO_CLICKED = "onVideoClicked"; // 视频点击
    const val ON_VIDEO_PLAY_ERROR = "onVideoPlayError" // Video playback error
}

object DownLoadCallBackChannelMethod {
    const val onDownloadPaused = "onDownloadPaused"
    const val onDownloadStarted = "onDownloadStarted"
    const val onDownloadProgressUpdate = "onDownloadProgressUpdate"
    const val onDownloadFinished = "onDownloadFinished"
    const val onDownloadFailed = "onDownloadFailed"
    const val onInstalled = "onInstalled"
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
    const val NATIVE_LOAD = "BeiZiNative_load"
    const val NATIVE_SHOW_AD = "BeiZiNative_showAd"
    const val NATIVE_GET_ECPM = "BeiZiNative_getECPM"
    const val NATIVE_NOTIFY_RTB_WIN = "BeiZiNative_notifyRTBWin"
    const val NATIVE_NOTIFY_RTB_LOSS = "BeiZiNative_notifyRTBLoss"
    const val NATIVE_IS_READY_AD = "BeiZiNative_isReadyAd"
    const val NATIVE_IS_NATIVE_EXPRESS = "BeiZiNative_isNativeExpress"
    const val NATIVE_GET_VIDEO_DURATION = "BeiZiNative_getVideoDuration"
    const val NATIVE_SET_VIDEO_PLAY_CONFIG = "BeiZiNative_setVideoPlayConfig"
}

object BeiZiSplashKeys {
    const val WIDTH = "width"
    const val HEIGHT = "height"
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

// Constants for argument keys or other string values
const val SPACE_ID = "spaceId"
const val TIME_OUT = "mTimeout"
const val NATIVE_WIDTH = "width"
const val NATIVE_TYPE = "nativeType"
const val AD_WIN_PRICE = "winPrice"
const val AD_SEC_PRICE = "secPrice"
const val AD_ID = "adId"
const val AD_LOSS_REASON = "lossReason"
const val AD_OPTION = "AdOption"
const val CONFIG = "config"
const val SPLASH_BOTTOM = "SplashBottomView"
const val VIDEO_SOUND = "videoSoundEnable"
const val VIDEO_PLAY_TYPE = "videoAutoPlayType"
const val VIDEO_LOOP_REPLAY = "videoLoopReplay"

enum class NativeType(val value: Int) {
    // 原生广告
    NATIVE(0),

    // 原生自渲染
    UNIFIED(1);
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
    BeiZiSdkMethodNames.NATIVE_LOAD,
    BeiZiSdkMethodNames.NATIVE_SHOW_AD,
    BeiZiSdkMethodNames.NATIVE_GET_ECPM,
    BeiZiSdkMethodNames.NATIVE_NOTIFY_RTB_WIN,
    BeiZiSdkMethodNames.NATIVE_NOTIFY_RTB_LOSS,
    BeiZiSdkMethodNames.NATIVE_IS_READY_AD,
    BeiZiSdkMethodNames.NATIVE_IS_NATIVE_EXPRESS,
    BeiZiSdkMethodNames.NATIVE_GET_VIDEO_DURATION,
    BeiZiSdkMethodNames.NATIVE_SET_VIDEO_PLAY_CONFIG
)

