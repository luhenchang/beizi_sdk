import 'dart:core';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import '../beizi_sdk.dart';
import '../common.dart';
import '../data/beizi_listener.dart';
import '../widget/splash_bottom_widget.dart';

/// 广告事件监听器
class SplashAdListener {
  final VoidCallback? onAdLoaded;
  final VoidCallback? onAdShown;
  final AdFailureCallback? onAdFailedToLoad;
  final VoidCallback? onAdClosed;
  final AdTickCallback? onAdTick;
  final VoidCallback? onAdClicked;

  SplashAdListener({
    this.onAdLoaded,
    this.onAdShown,
    this.onAdFailedToLoad,
    this.onAdClosed,
    this.onAdTick,
    this.onAdClicked,
  });
}

class SplashAd {
  final String adSpaceId;
  final int totalTime;
  final SplashAdListener listener;
  final String? spaceParam;
  SplashAd({
    required this.adSpaceId,
    required this.totalTime,
    required this.listener,
    this.spaceParam
  }) {
    _setMethodCallHandler();
    BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.splashCreate, {
      'adSpaceId': adSpaceId,
      'totalTime': totalTime,
      'spaceParam': spaceParam
    });
  }

  Future<void> loadAd({
    required int width,
    required int height,
    SplashBottomWidget? splashBottomWidget
  }) async {
    await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.splashLoad, {
      'width': width,
      'height': height,
      'bottomWidget': splashBottomWidget?.toMap()
    });
  }

  ///开屏广告显示调用
  void showAd() async {
    await BeiziSdk.channel.invokeMethod(
        BeiZiSdkMethodNames.splashShowAd);
  }

  void _setMethodCallHandler() {
    BeiziSdk.channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case BeiZiAdCallBackChannelMethod.onAdLoaded:
          listener.onAdLoaded?.call();
          break;
        case BeiZiAdCallBackChannelMethod.onAdShown:
          listener.onAdShown?.call();
          break;
        case BeiZiAdCallBackChannelMethod.onAdFailedToLoad:
          listener.onAdFailedToLoad?.call(call.arguments as int);
          break;
        case BeiZiAdCallBackChannelMethod.onAdClosed:
          listener.onAdClosed?.call();
          break;
        case BeiZiAdCallBackChannelMethod.onAdTick:
          listener.onAdTick?.call(call.arguments as Long);
          break;
        case BeiZiAdCallBackChannelMethod.onAdClicked:
          listener.onAdClicked?.call();
          break;
        default:
          break;
      }
    });
  }

  ///单位：人民币（分）
  Future<int> getECPM() async {
    return await BeiziSdk.channel
        .invokeMethod(BeiZiSdkMethodNames.splashGetECPM);
  }

  /// 注意：必须为有效的字符串格式的键值对！！！！！
  /// @param winInfo 竞胜信息
  /// BeiZiBiddingConstant.KEY_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
  /// BeiZiBiddingConstant.KEY_ADN_ID ：失败渠道中最高价格渠道ID，必填（value值使用BeiZiBiddingConstant.Adn类下的常量字符串即可）
  /// BeiZiBiddingConstant.KEY_HIGHEST_LOSS_PRICE ：失败渠道中最高价格，必填（value值使用字符串即可）
  Future<void> sendWinNotificationWithInfo(Map<String, String> winInfo) async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.splashNotifyRTBWin, winInfo);
    } on PlatformException catch (e) {
      // 处理调用异常
      throw Exception('调用sendWinNotificationWithInfo失败: ${e.message}');
    }
  }

  /// 注意：必须为有效的字符串格式的键值对！！！！！
  /// @param lossInfo 竞败信息
  /// BeiZiBiddingConstant.KEY_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
  /// BeiZiBiddingConstant.KEY_ADN_ID ：竞胜渠道ID，必填（value值使用BeiZiBiddingConstant.Adn类下的常量字符串即可）
  /// BeiZiBiddingConstant.KEY_LOSS_REASON ：失败原因，必填（value值使用BeiZiBiddingConstant.LossReason类下的常量字符串即可）
  Future<void> sendLossNotificationWithInfo(
      Map<String, String> lossInfo) async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.splashNotifyRTBLoss, lossInfo);
    } on PlatformException catch (e) {
      throw Exception('调用sendLossNotificationWithInfo失败: ${e.message}');
    }
  }

  Future<String?> getCustomExtraJsonData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.splashGetCustomJsonData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraJsonData失败: ${e.message}');
    }
  }

  /// Android 返回 String?类型
  /// IOS 返回 Map 类型
  Future<dynamic> getCustomExtraData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.splashGetCustomExtData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }

  ///only support ios
  Future<Map<String, dynamic>?> getCustomParam() async {
    if(Platform.isAndroid) {
      return null;
    }
    try {
      final dynamic param = await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.splashGetCustomParam);
      if (param == null){
        return null;
      }
      return Map<String, dynamic>.from(param);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }

  void setBidResponse(String content) {
    try {
      BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.splashSetBidResponse, content);
    } on PlatformException catch (e) {
      throw Exception('调用setBidResponse失败: ${e.message}');
    }
  }

  //提供android使用
  void setSpaceParam(Map<String, Object> map) {
    try {
      BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.splashSetSpaceParam, map);
    } on PlatformException catch (e) {
      throw Exception('调用setSpaceParam失败: ${e.message}');
    }
  }

  ///splashAd.cancel
  void cancel() {
    try {
      BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.splashCancel);
    } on PlatformException catch (e) {
      throw Exception('调用cancel失败: ${e.message}');
    }
  }

}
