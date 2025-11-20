const String channelDomain = "com.beizi.sdk";

class BeiZiPlatformViewRegistry {
  static const beiZiSdkSplashViewId = '$channelDomain/splash_view_id';
  static const beiZiSdkInterstitialViewId =
      '$channelDomain/interstitial_view_id';
  static const beiZiSdkNativeViewId = '$channelDomain/native_view_id';
  static const beiZiSdkUnifiedViewId = '$channelDomain/native_unified_view_id';
}

class BeiZiSdkMethodNames {
  /// 初始化AMPS广告SDK的方法名
  static const String init = 'BeiZiSdk_init';

  /// 开屏相关方法
  static const String splashCreate = 'BeiZiSplashAd_create';
  static const String splashLoad = 'BeiZiSplashAd_load';
  static const String splashShowAd = 'BeiZiSplashAd_showAd';
  static const String splashGetECPM = 'BeiZiSplashAd_getECPM';
  static const String splashNotifyRTBWin = 'BeiZiSplashAd_notifyRTBWin';
  static const String splashNotifyRTBLoss = 'BeiZiSplashAd_notifyRTBLoss';
  static const String splashGetCustomExtData = 'BeiZiSplashAd_getCustomExtData';
  static const String splashGetCustomParam = 'BeiZiSplashAd_getCustomParam';
  static const String splashGetCustomJsonData =
      "BeiZiSplashAd_getCustomJsonData";
  static const String splashSetBidResponse = 'BeiZiSplashAd_setBidResponse';
  static const String splashSetSpaceParam = 'BeiZiSplashAd_setSpaceParam';
  static const String splashCancel = 'BeiZiSplashAd_Cancel';

  ///插屏相关方法
  static const String interstitialCreate = "BeiZiInterstitial_create";
  static const String interstitialLoad = "BeiZiInterstitial_load";
  static const String interstitialShowAd = "BeiZiSInterstitial_showAd";
  static const String interstitialIsLoaded = "BeiZiSInterstitial_isLoaded";
  static const String interstitialSetAdVersion = "BeiZiInterstitial_setAdVersion";
  static const String interstitialGetEcpm = "BeiZiSInterstitial_getECPM";
  static const String interstitialNotifyRtbWin =
      "BeiZiInterstitial_notifyRTBWin";
  static const String interstitialNotifyRtbLoss =
      "BeiZiInterstitial_notifyRTBLoss";
  static const String interstitialGetCustomExtData =
      "BeiZiInterstitial_getCustomExtData";
  static const String interstitialGetCustomJsonData =
      "BeiZiInterstitial_getCustomJsonData";
  static const String interstitialSetBidResponse =
      "BeiZiInterstitial_setBidResponse";
  static const String interstitialSetSpaceParam =
      "BeiZiInterstitial_setSpaceParam";
  static const String interstitialGetCustomParam = 'BeiZiInterstitial_getCustomParam';
  static const String interstitialDestroy = "BeiZiInterstitial_Destroy";

  ///激励视频相关方法
  static const String rewardedVideoCreate = "BeiZiRewardedVideo_create";
  static const String rewardedVideoLoad = "BeiZiRewardedVideo_load";
  static const String rewardedVideoShowAd = "BeiZiSRewardedVideo_showAd";
  static const String rewardedVideoIsLoaded = "BeiZiSRewardedVideo_isLoaded";
  static const String rewardedVideoGetUserId = "BeiZiSRewardedVideo_getUserId";
  static const String rewardedVideoSetUserId = "BeiZiSRewardedVideo_setUserId";
  static const String rewardedVideoGetEcpm = "BeiZiSRewardedVideo_getECPM";
  static const String rewardedVideoNotifyRtbWin = "BeiZiRewardedVideo_notifyRTBWin";
  static const String rewardedVideoNotifyRtbLoss = "BeiZiRewardedVideo_notifyRTBLoss";
  static const String rewardedVideoGetExtra = "BeiZiRewardedVideo_getExtra";
  static const String rewardedVideoSetExtra = "BeiZiRewardedVideo_setExtra";
  static const String rewardedVideoGetCustomExtData = "BeiZiRewardedVideo_getCustomExtData";
  static const String rewardedVideoGetCustomJsonData = "BeiZiRewardedVideo_getCustomJsonData";
  static const String rewardedVideoSetBidResponse = "BeiZiRewardedVideo_setBidResponse";
  static const String rewardedVideoSetSpaceParam = "BeiZiRewardedVideo_setSpaceParam";
  static const String rewardedVideoDestroy = "BeiZiRewardedVideo_Destroy";

  //原生相关方法
  static const String nativeCreate = "BeiZiNative_create";
  static const String nativeLoad = "BeiZiNative_load";
  static const String nativeResume = "BeiZiNative_resume";
  static const String nativePause = "BeiZiNative_pause";
  static const String nativeGetEcpm = "BeiZiNative_getECPM";
  static const String nativeDestroy = "BeiZiNative_destroy";
  static const String nativeGetCustomExtData = "BeiZiNative_getCustomExtData";
  static const String nativeGetCustomJsonData = "BeiZiNative_getCustomJsonData";
  static const String nativeNotifyRtbWin = "BeiZiNative_notifyRTBWin";
  static const String nativeNotifyRtbLoss = "BeiZiNative_notifyRTBLoss";
  static const String nativeSetBidResponse = "BeiZiNative_setBidResponse";
  static const String nativeSetSpaceParam = "BeiZiNative_setSpaceParam";
  static const String nativeGetCustomParam = 'BeiZiNative_getCustomParam';

  // Native Unified ad related methods
  static const String nativeUnifiedCreate = "BeiZiNativeUnified_create";
  static const String nativeUnifiedSetHide = "BeiZiNativeUnified_setHide";
  static const String nativeUnifiedLoad = "BeiZiNativeUnified_load";
  static const String nativeUnifiedGetDownLoad = "BeiZiNativeUnified_getDownLoad";
  static const String nativeUnifiedResume = "BeiZiNativeUnified_resume";
  static const String nativeUnifiedMaterialType = "BeiZiNativeUnified_materialType";
  static const String nativeUnifiedGetEcpm = "BeiZiNativeUnified_getECPM";
  static const String nativeUnifiedDestroy = "BeiZiNativeUnified_destroy";
  static const String nativeUnifiedGetCustomExtData =
      "BeiZiNativeUnified_getCustomExtData";
  static const String nativeUnifiedGetCustomJsonData =
      "BeiZiNativeUnified_getCustomJsonData";
  static const String nativeUnifiedNotifyRtbWin =
      "BeiZiNativeUnified_notifyRTBWin";
  static const String nativeUnifiedNotifyRtbLoss =
      "BeiZiNativeUnified_notifyRTBLoss";
  static const String nativeUnifiedSetBidResponse =
      "BeiZiNativeUnified_setBidResponse";
  static const String nativeUnifiedSetSpaceParam =
      "BeiZiNativeUnified_setSpaceParam";
  static const String nativeUnifiedGetCustomParam = 'BeiZiNativeUnified_getCustomParam';
}

class BeiZiAdCallBackChannelMethod {
  /// 广告加载成功
  static const String onAdLoaded = "onAdLoaded";
  /// 广告展示成功
  static const String onAdShown = "onAdShown";
  /// 广告加载失败
  static const String onAdFailedToLoad = "onAdFailedToLoad";
  /// 广告关闭 (开屏广告结束/用户跳过)
  static const String onAdClosed = "onAdClosed";
  /// 广告倒计时/进度更新
  static const String onAdTick = "onAdTick";
  /// 广告被点击
  static const String onAdClicked = "onAdClicked";
}

/// 用于 EventChannel 接收 Native 端插屏广告回调的事件类型
class BeiZiInterstitialAdChannelMethod {
  /// 广告加载成功
  static const String onAdLoaded = "Inter_onAdLoaded";
  /// 广告展示成功
  static const String onAdShown = "Inter_onAdShown";
  /// 广告加载失败
  static const String onAdFailed = "Inter_onAdFailed";
  /// 广告关闭 (例如：用户关闭插屏弹窗)
  static const String onAdClosed = "Inter_onAdClosed";
  /// 广告被点击
  static const String onAdClicked = "Inter_onAdClicked";
}

/// 激励视频广告相关方法
class BeiZiRewardedVideoAdChannelMethod {
  /// 广告激励发放
  static const String onRewarded = "Reward_onRewarded";
  /// 广告加载失败
  static const String onRewardedVideoAdFailedToLoad = "Reward_onAdFailedToLoad";
  /// 广告加载成功
  static const String onRewardedVideoAdLoaded = "Reward_onAdLoaded";
  /// 广告缓存成功
  static const String onRewardedVideoCacheSuccess = "Reward_onCacheSuccess";
  /// 广告展示成功
  static const String onRewardedVideoAdShown = "Reward_onAdShown";
  /// 广告关闭
  static const String onRewardedVideoAdClosed = "Reward_onAdClosed";
  /// 广告被点击
  static const String onRewardedVideoClick = "Reward_onAdClicked";
  /// 广告播放完成
  static const String onRewardedVideoComplete = "Reward_onAdComplete";
  /// 广告播放错误
  static const String onRewardedVideoPlayError = "Reward_onPlayError";
}

/// 用于 EventChannel 接收 Native 端原生广告回调的事件类型
class BeiZiNativeAdChannelMethod {
  /// 广告加载失败
  static const String onAdFailed = "Native_onAdFailed";
  /// 广告加载成功
  static const String onAdLoaded = "Native_onAdLoaded";
  /// 广告展示成功
  static const String onAdShown = "Native_onAdShown";
  /// 广告关闭
  static const String onAdClosed = "Native_onAdClosed";
  /// 广告视图关闭
  static const String onAdClosedView = "Native_onAdClosedView";
  /// 广告被点击
  static const String onAdClicked = "Native_onAdClick";
}

class BeiZiNativeUnifiedAdChannelMethod {
  /// 广告加载失败
  static const String onAdFailed = "Native_Unified_onAdFailed";
  /// 广告加载成功
  static const String onAdLoaded = "Native_Unified_onAdLoaded";
  /// 广告展示成功
  static const String onAdShown = "Native_Unified_onAdShown";
  /// 广告关闭
  static const String onAdClosed = "Native_Unified_onAdClosed";
  /// 广告被点击
  static const String onAdClick = "Native_Unified_onAdClick";
}