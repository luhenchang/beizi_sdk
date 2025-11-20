import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../beizi_sdk.dart';
import '../common.dart';
import '../data/beizi_listener.dart';

// 广告事件监听器
class RewardedVideoAdListener {
  final VoidCallback? onRewarded;
  final AdFailureCallback? onRewardedVideoAdFailedToLoad;
  final VoidCallback? onRewardedVideoAdLoaded;
  final VoidCallback? onRewardedVideoCacheSuccess;
  final VoidCallback? onRewardedVideoAdShown;
  final VoidCallback? onRewardedVideoAdClosed;
  final VoidCallback? onRewardedVideoClick;
  final VoidCallback? onRewardedVideoComplete;
  final VoidCallback? onRewardedVideoPlayError;

  RewardedVideoAdListener(
      {this.onRewarded,
      this.onRewardedVideoAdFailedToLoad,
      this.onRewardedVideoAdLoaded,
      this.onRewardedVideoCacheSuccess,
      this.onRewardedVideoAdShown,
      this.onRewardedVideoAdClosed,
      this.onRewardedVideoClick,
      this.onRewardedVideoComplete,
      this.onRewardedVideoPlayError});
}

/// 激励视频广告构造函数
/// @param adSpaceId 广告位id，由运营人员提供
/// @param mAdListener 激励视频广告监听
/// @param totalTime 广告超时时长，单位毫秒，建议10秒（10000）以上
/// @param modelType 模板类型，1表示平台模板1.0，默认为1；2表示平台模板2.0；传2即可
class RewardedVideoAd {
  final String adSpaceId;
  final int totalTime;
  final int? modelType;
  final RewardedVideoAdListener listener;
  final String? spaceParam;
  // 构造函数
  RewardedVideoAd(
      {required this.adSpaceId,
      required this.totalTime,
      required this.listener,
      this.modelType,
      this.spaceParam}) {
    _setMethodCallHandler();
    //调用 Native 方法，并传递参数
    BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.rewardedVideoCreate, {
      'adSpaceId': adSpaceId,
      'totalTime': totalTime,
      'modelType': modelType,
      'spaceParam': spaceParam
    });
  }

  Future<void> loadAd() async {
    //调用 Native 方法，并传递参数
    await BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.rewardedVideoLoad);
  }

  void showAd() async {
    await BeiziSdk.channel.invokeMethod(
        BeiZiSdkMethodNames.rewardedVideoShowAd);
  }

  Future<bool> isLoaded() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.rewardedVideoLoad);
    } on PlatformException catch (e) {
      debugPrint('调用isLoaded失败: ${e.message}');
      return false;
    }
  }

  void _setMethodCallHandler() {
    BeiziSdk.channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case BeiZiRewardedVideoAdChannelMethod.onRewarded:
          listener.onRewarded?.call();
          break;
        case BeiZiRewardedVideoAdChannelMethod.onRewardedVideoAdFailedToLoad:
          // 传递错误信息给失败回调（假设参数中包含错误信息）
          listener.onRewardedVideoAdFailedToLoad?.call(call.arguments as int);
          break;
        case BeiZiRewardedVideoAdChannelMethod.onRewardedVideoAdLoaded:
          listener.onRewardedVideoAdLoaded?.call();
          break;
        case BeiZiRewardedVideoAdChannelMethod.onRewardedVideoCacheSuccess:
          listener.onRewardedVideoCacheSuccess?.call();
          break;
        case BeiZiRewardedVideoAdChannelMethod.onRewardedVideoAdShown:
          listener.onRewardedVideoAdShown?.call();
          break;
        case BeiZiRewardedVideoAdChannelMethod.onRewardedVideoAdClosed:
          listener.onRewardedVideoAdClosed?.call();
          break;
        case BeiZiRewardedVideoAdChannelMethod.onRewardedVideoClick:
          listener.onRewardedVideoClick?.call();
          break;
        case BeiZiRewardedVideoAdChannelMethod.onRewardedVideoComplete:
          listener.onRewardedVideoComplete?.call();
          break;
        case BeiZiRewardedVideoAdChannelMethod.onRewardedVideoPlayError:
          listener.onRewardedVideoPlayError?.call();
          break;
        default:
          break;
      }
    });
  }

  ///单位：人民币（分）
  Future<int> getECPM() async {
    return await BeiziSdk.channel
        .invokeMethod(BeiZiSdkMethodNames.rewardedVideoGetEcpm);
  }

  /// 注意：必须为有效的字符串格式的键值对！！！！！
  /// @param winInfo 竞胜信息
  /// BeiZiBiddingConstant.KEY_WIN_PRICE ：竞胜价格 (单位: 分; 整数)，必填（value值使用字符串即可）
  /// BeiZiBiddingConstant.KEY_ADN_ID ：失败渠道中最高价格渠道ID，必填（value值使用BeiZiBiddingConstant.Adn类下的常量字符串即可）
  /// BeiZiBiddingConstant.KEY_HIGHEST_LOSS_PRICE ：失败渠道中最高价格，必填（value值使用字符串即可）
  Future<void> sendWinNotificationWithInfo(Map<String, String> winInfo) async {
    try {
      await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.rewardedVideoNotifyRtbWin, winInfo);
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
          BeiZiSdkMethodNames.rewardedVideoNotifyRtbLoss, lossInfo);
    } on PlatformException catch (e) {
      throw Exception('调用sendLossNotificationWithInfo失败: ${e.message}');
    }
  }

  Future<String?> getCustomExtraJsonData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.rewardedVideoGetCustomJsonData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraJsonData失败: ${e.message}');
    }
  }

  setExtraData(String data) {
    try {
      BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.rewardedVideoSetExtra,data);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }

  Future<String?> getExtraData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.rewardedVideoGetExtra);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }

  ///开发者根据不同平台进行处理
  /// Android 返回 String?类型
  /// IOS 返回 Map? 类型
  Future<dynamic> getCustomExtraData() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.rewardedVideoGetCustomExtData);
    } on PlatformException catch (e) {
      throw Exception('调用getCustomExtraData失败: ${e.message}');
    }
  }

  setBidResponse(String content) {
    try {
      BeiziSdk.channel.invokeMethod(
          BeiZiSdkMethodNames.rewardedVideoSetBidResponse, content);
    } on PlatformException catch (e) {
      throw Exception('调用setBidResponse失败: ${e.message}');
    }
  }

  setSpaceParam(Map<String, Object> map) {
    try {
      BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.rewardedVideoSetSpaceParam, map);
    } on PlatformException catch (e) {
      throw Exception('调用setSpaceParam失败: ${e.message}');
    }
  }

  setUserId(String userId) {
    BeiziSdk.channel
        .invokeMethod(BeiZiSdkMethodNames.rewardedVideoSetUserId, userId);
  }

  Future<String?> getUserId() async {
    try {
      return await BeiziSdk.channel
          .invokeMethod(BeiZiSdkMethodNames.rewardedVideoGetUserId);
    } on PlatformException catch (e) {
      throw Exception('调用getUserId失败: ${e.message}');
    }
  }

  ///RewardedVideoAd.destroy
  destroy() {
    try {
      BeiziSdk.channel.invokeMethod(BeiZiSdkMethodNames.rewardedVideoDestroy);
    } on PlatformException catch (e) {
      throw Exception('调用cancel失败: ${e.message}');
    }
  }
}
