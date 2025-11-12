import 'dart:core';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../beizi_sdk.dart';
import '../common.dart';
import '../data/beizi_listener.dart';

// 广告事件监听器
class InterstitialAdListener {
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdShown;
  final AdFailureCallback? onAdFailed;
  final VoidCallback? onAdClosed;
  final VoidCallback? onAdClick;

  InterstitialAdListener({
    this.onAdLoaded,
    this.onAdShown,
    this.onAdFailed,
    this.onAdClosed,
    this.onAdClick,
  });
}

class InterstitialAd {
  final String adSpaceId;
  final int totalTime;
  final int? modelType;
  final InterstitialAdListener listener;

  // 构造函数
  InterstitialAd(
      {required this.adSpaceId,
      required this.totalTime,
      required this.listener,
      this.modelType}) {
    _setMethodCallHandler();
    //调用 Native 方法，并传递参数
    BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.interstitialCreate, {
      'adSpaceId': adSpaceId,
      'totalTime': totalTime,
      'modelType': modelType
    });
  }

  Future<void> setAdVersion(Int ver) async{
    await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.interstitialSetAdVersion,ver);
  }

  Future<void> loadAd() async {
    //调用 Native 方法，并传递参数
    await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.interstitialLoad);
  }

  ///插屏广告显示调用
  void showAd() async {
    try {
      await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.interstitialShowAd);
    } on PlatformException catch (e) {
      debugPrint('调用showAd失败: ${e.details}');
    }
  }

  Future<bool> isLoaded() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.interstitialIsLoaded);
    } on PlatformException catch (e) {
      debugPrint('调用isLoaded失败: ${e.message}');
      return false;
    }
  }

  void _setMethodCallHandler() {
    BeiziSdk.channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case BeiZiInterstitialAdChannelMethod.onAdLoaded:
          listener.onAdLoaded?.call();
          break;
        case BeiZiInterstitialAdChannelMethod.onAdShown:
          listener.onAdShown?.call();
          break;
        case BeiZiInterstitialAdChannelMethod.onAdFailed:
          listener.onAdFailed?.call(call.arguments as int);
          break;
        case BeiZiInterstitialAdChannelMethod.onAdClosed:
          listener.onAdClosed?.call();
          break;
        case BeiZiInterstitialAdChannelMethod.onAdClicked:
          listener.onAdClick?.call();
          break;
        default:
          break;
      }
    });
  }

  ///单位：人民币（分）
  Future<int> getECPM() async {
    return await BeiziSdk.channel
        .invokeMethod(BeiZiSdkMethodNames.interstitialGetEcpm);
  }

  /// 注意：必须为有效的字符串格式的键值对！！！！！
  /// @param winInfo 竞胜信息，Map<String,String>类型
  /// BeiZiBiddingConstant.KEY_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
  /// BeiZiBiddingConstant.KEY_ADN_ID ：失败渠道中最高价格渠道ID，必填（value值使用BeiZiBiddingConstant.Adn类下的常量字符串即可）
  /// BeiZiBiddingConstant.KEY_HIGHEST_LOSS_PRICE ：失败渠道中最高价格，必填（value值使用字符串即可）
  Future<void> sendWinNotificationWithInfo(Map<String, String> winInfo) async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.interstitialNotifyRtbWin, winInfo);
    } on PlatformException catch (e) {
      // 处理调用异常
      throw Exception('调用sendWinNotificationWithInfo失败: ${e.message}');
    }
  }

  /// 注意：必须为有效的字符串格式的键值对！！！！！
  /// @param lossInfo 竞败信息，Map<String,String>类型
  /// BeiZiBiddingConstant.KEY_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
  /// BeiZiBiddingConstant.KEY_ADN_ID ：竞胜渠道ID，必填（value值使用BeiZiBiddingConstant.Adn类下的常量字符串即可）
  /// BeiZiBiddingConstant.KEY_LOSS_REASON ：失败原因，必填（value值使用BeiZiBiddingConstant.LossReason类下的常量字符串即可）
  Future<void> sendLossNotificationWithInfo(
      Map<String, String> lossInfo) async {
    try {
      await BeiziSdk.channel.invokeMethod(
          BeiZiSdkMethodNames.interstitialNotifyRtbLoss, lossInfo);
    } on PlatformException catch (e) {
      throw Exception('调用sendLossNotificationWithInfo失败: ${e.message}');
    }
  }

  Future<String> getCustomExtraJsonData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.interstitialGetCustomJsonData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraJsonData失败: ${e.message}');
    }
  }

  Future<String> getCustomExtraData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.interstitialGetCustomExtData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }

  ///
  /// ios使用
  Future<Map<String, dynamic>?> getCustomParam() async {
    try {
      final dynamic param = await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.interstitialGetCustomParam);
      if (param == null){
        return null;
      }
      return Map<String, dynamic>.from(param);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }

  setBidResponse(String content) {
    try {
      BeiziSdk.channel.invokeMethod(
          BeiZiSdkMethodNames.interstitialSetBidResponse, content);
    } on PlatformException catch (e) {
      throw Exception('调用setBidResponse失败: ${e.message}');
    }
  }

  setSpaceParam(Map<String, Object> map) {
    try {
      BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.interstitialSetSpaceParam, map);
    } on PlatformException catch (e) {
      throw Exception('调用setSpaceParam失败: ${e.message}');
    }
  }

  ///InterstitialAd.cancel
  destroy() {
    try {
      BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.interstitialDestroy);
    } on PlatformException catch (e) {
      throw Exception('调用cancel失败: ${e.message}');
    }
  }
}
