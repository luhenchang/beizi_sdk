import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../beizi_sdk.dart';
import '../common.dart';
import '../data/beizi_unified_native_listener.dart';
import '../data/unified_ad_download_app_info.dart';

///原生广告类
class BeiZiUnifiedNativeAd {
  final String adSpaceId;
  final int totalTime;
  final int? modelType;
  final List<num?>? expressSize;
  final String? spaceParam;
  double? adWidth;
  double? adHeight;
  BeiZiUnifiedNativeAdListener? listener;
  AdWidgetNeedCloseCall? mCloseWidgetCall;

  // 构造函数
  BeiZiUnifiedNativeAd(
      {required this.adSpaceId,
      required this.totalTime,
      required this.listener,
      required this.expressSize,
      this.modelType,
      this.spaceParam}) {
    _setNativeAdMethodCallHandler();
    BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.nativeUnifiedCreate, {
      'adSpaceId': adSpaceId,
      'totalTime': totalTime,
      'modelType': modelType,
      'spaceParam': spaceParam
    });
  }

  Future<bool> setHide(Map<String, dynamic> map) async {
    return await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.nativeUnifiedSetHide, map);
  }

  Future<void> loadAd() async {
    //调用 Native 方法，并传递参数
    await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.nativeUnifiedLoad);
  }

  ///广告resume
  void resume() async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeUnifiedResume);
    } on PlatformException catch (e) {
      debugPrint('调用resume失败: ${e.details}');
    }
  }

  /// 原生广告管理类中的方法调用处理器设置
  void _setNativeAdMethodCallHandler() {
    // 假设使用与插屏广告相同的channel，也可以根据需要使用单独的channel
    BeiziSdk.channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case BeiZiNativeUnifiedAdChannelMethod.onAdLoaded:
          listener?.onAdLoaded?.call(call.arguments);
          break;
        case BeiZiNativeUnifiedAdChannelMethod.onAdShown:
          listener?.onAdShown?.call();
          break;
        case BeiZiNativeUnifiedAdChannelMethod.onAdFailed:
          // 传递错误码给回调
          listener?.onAdFailed?.call(call.arguments as int);
          break;
        case BeiZiNativeUnifiedAdChannelMethod.onAdClick:
          listener?.onAdClicked?.call();
          break;
        case BeiZiNativeUnifiedAdChannelMethod.onAdClosed:
          listener?.onAdClosed?.call(call.arguments);
          break;
        default:
          break;
      }
    });
  }

  Future<int> getMaterialType(String adId) async {
    return await BeiziSdk.channel
        .invokeMethod(BeiZiSdkMethodNames.nativeUnifiedMaterialType, adId);
  }

  ///单位：人民币（分）
  Future<int> getECPM() async {
    return await BeiziSdk.channel
        .invokeMethod(BeiZiSdkMethodNames.nativeUnifiedGetEcpm);
  }

  /// 注意：必须为有效的字符串格式的键值对！！！！！
  /// @param winInfo 竞胜信息，Map<String,String>类型
  /// BeiZiBiddingConstant.KEY_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
  /// BeiZiBiddingConstant.KEY_ADN_ID ：失败渠道中最高价格渠道ID，必填（value值使用BeiZiBiddingConstant.Adn类下的常量字符串即可）
  /// BeiZiBiddingConstant.KEY_HIGHEST_LOSS_PRICE ：失败渠道中最高价格，必填（value值使用字符串即可）
  Future<void> sendWinNotificationWithInfo(Map<String, String> winInfo) async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeUnifiedNotifyRtbWin, winInfo);
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
          BeiZiSdkMethodNames.nativeUnifiedNotifyRtbLoss, lossInfo);
    } on PlatformException catch (e) {
      throw Exception('调用sendLossNotificationWithInfo失败: ${e.message}');
    }
  }

  Future<String?> getCustomExtraJsonData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeUnifiedGetCustomJsonData);
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
          .invokeMethod(BeiZiSdkMethodNames.nativeUnifiedGetCustomExtData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }

  setBidResponse(String content) {
    try {
      BeiziSdk.channel.invokeMethod(
          BeiZiSdkMethodNames.nativeUnifiedSetBidResponse, content);
    } on PlatformException catch (e) {
      throw Exception('调用setBidResponse失败: ${e.message}');
    }
  }

  setSpaceParam(Map<String, Object> map) {
    try {
      BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.nativeUnifiedSetSpaceParam, map);
    } on PlatformException catch (e) {
      throw Exception('调用setSpaceParam失败: ${e.message}');
    }
  }

  Future<UnifiedAdDownloadAppInfo?> getDownLoadInfo(String adId) async {
    try {
      final dynamic appInfo = await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.nativeUnifiedGetDownLoad, adId);
      Map<String, dynamic>? dataMap;
      if(appInfo != null) {
        dataMap = Map<String, dynamic>.from(appInfo);
      }
      return UnifiedAdDownloadAppInfo.fromMap(dataMap);
    } on PlatformException catch (e) {
      throw Exception('调用getDownLoadInfo失败: ${e.message}');
    }
  }

  ///InterstitialAd.cancel
  destroy() {
    try {
      BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.nativeUnifiedDestroy);
    } on PlatformException catch (e) {
      throw Exception('调用cancel失败: ${e.message}');
    }
  }

  void setAdCloseCallBack(AdWidgetNeedCloseCall? closeWidgetCall) {
    mCloseWidgetCall = closeWidgetCall;
  }
}
