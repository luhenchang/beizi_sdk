import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../beizi_sdk.dart';
import '../common.dart';
import '../data/beizi_native_listener.dart';

///原生广告类
class BeiZiNativeAd {
  final String adSpaceId;
  final int totalTime;
  final int? modelType;
  final String? spaceParam;
  double? adWidth;
  double? adHeight;
  BeiZiNativeAdListener? listener;
  AdWidgetNeedCloseCall? mCloseWidgetCall;

  // 构造函数
  BeiZiNativeAd(
      {required this.adSpaceId,
      required this.totalTime,
      required this.listener,
      this.modelType,
      this.spaceParam}) {
    _setNativeAdMethodCallHandler();
    BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.nativeCreate, {
      'adSpaceId': adSpaceId,
      'totalTime': totalTime,
      'modelType': modelType,
      'spaceParam': spaceParam
    });
  }

  Future<void> loadAd({
    required double width,
    required double height,
  }) async {
    adWidth = width;
    adHeight = height;
    //调用 Native 方法，并传递参数
    await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.nativeLoad, {
      'width': width,
      'height': height
    });
  }

  ///广告resume
  void resume() async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeResume);
    } on PlatformException catch (e) {
      debugPrint('调用resume失败: ${e.details}');
    }
  }

  ///广告pause
  void pause() async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativePause);
    } on PlatformException catch (e) {
      debugPrint('调用pause失败: ${e.details}');
    }
  }

  /// 原生广告管理类中的方法调用处理器设置
  void _setNativeAdMethodCallHandler() {
    // 假设使用与插屏广告相同的channel，也可以根据需要使用单独的channel
    BeiziSdk.channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case BeiZiNativeAdChannelMethod.onAdLoaded:
          listener?.onAdLoaded?.call(call.arguments);
          break;
        case BeiZiNativeAdChannelMethod.onAdShown:
          listener?.onAdShown?.call();
          break;
        case BeiZiNativeAdChannelMethod.onAdFailed:
          // 传递错误码给回调
          listener?.onAdFailed?.call(call.arguments as int);
          break;
        case BeiZiNativeAdChannelMethod.onAdClosed:
          mCloseWidgetCall?.call();
          listener?.onAdClosed?.call();
          break;
        case BeiZiNativeAdChannelMethod.onAdClosedView:
          mCloseWidgetCall?.call();
          listener?.onAdClosedView?.call();
          break;
        case BeiZiNativeAdChannelMethod.onAdClicked:
          listener?.onAdClicked?.call();
          break;
        default:
          break;
      }
    });
  }

  ///单位：人民币（分）
  Future<int> getECPM() async {
    return await BeiziSdk.channel
        .invokeMethod(BeiZiSdkMethodNames.nativeGetEcpm);
  }

  /// 注意：必须为有效的字符串格式的键值对！！！！！
  /// @param winInfo 竞胜信息
  /// BeiZiBiddingConstant.KEY_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
  /// BeiZiBiddingConstant.KEY_ADN_ID ：失败渠道中最高价格渠道ID，必填（value值使用BeiZiBiddingConstant.Adn类下的常量字符串即可）
  /// BeiZiBiddingConstant.KEY_HIGHEST_LOSS_PRICE ：失败渠道中最高价格，必填（value值使用字符串即可）
  Future<void> sendWinNotificationWithInfo(Map<String, String> winInfo) async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeNotifyRtbWin, winInfo);
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
      await BeiziSdk.channel.invokeMethod(
          BeiZiSdkMethodNames.nativeNotifyRtbLoss, lossInfo);
    } on PlatformException catch (e) {
      throw Exception('调用sendLossNotificationWithInfo失败: ${e.message}');
    }
  }

  Future<String?> getCustomExtraJsonData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeGetCustomJsonData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraJsonData失败: ${e.message}');
    }
  }

  ///开发者根据不同平台进行处理
  /// Android 返回 String?类型
  /// IOS 返回 Map? 类型
  Future<dynamic> getCustomExtraData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeGetCustomExtData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }
  ///开发者根据不同平台进行处理
  /// 只有 IOS 返回 Map? 类型 ，Android 返回 null类型
  Future<dynamic> getCustomParam() async {
    if (Platform.isAndroid){
      return null;
    }
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeGetCustomParam);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }
  setBidResponse(String content) {
    try {
      BeiziSdk.channel.invokeMethod(
          BeiZiSdkMethodNames.nativeSetBidResponse, content);
    } on PlatformException catch (e) {
      throw Exception('调用setBidResponse失败: ${e.message}');
    }
  }

  setSpaceParam(Map<String, Object> map) {
    try {
      BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeSetSpaceParam, map);
    } on PlatformException catch (e) {
      throw Exception('调用setSpaceParam失败: ${e.message}');
    }
  }

  ///InterstitialAd.cancel
  destroy() {
    try {
      BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.nativeDestroy);
    } on PlatformException catch (e) {
      throw Exception('调用cancel失败: ${e.message}');
    }
  }

  void setAdCloseCallBack(AdWidgetNeedCloseCall? closeWidgetCall) {
    mCloseWidgetCall = closeWidgetCall;
  }
}
