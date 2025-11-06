const String channelDomain = "com.beizi.sdk";

class BeiZiPlatformViewRegistry {
  static const beiZiSdkSplashViewId = '$channelDomain/splash_view_id';
  static const beiZiSdkInterstitialViewId = '$channelDomain/interstitial_view_id';
  static const beiZiSdkNativeViewId = '$channelDomain/native_view_id';
  static const beiZiSdkUnifiedViewId = '$channelDomain/unified_view_id';
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
  static const String splashGetCustomJsonData = "BeiZiSplashAd_getCustomJsonData";
  static const String splashSetBidResponse = 'BeiZiSplashAd_setBidResponse';
  static const String splashSetSpaceParam = 'BeiZiSplashAd_setSpaceParam';
  static const String splashCancel = 'BeiZiSplashAd_Cancel';
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