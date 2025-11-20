import 'dart:ui';

///原生和原生自渲染广告相关回调
///原生广告加载回调
/// 原生广告监听器
class BeiZiNativeAdListener {
  /// 广告加载成功回调
  final Function(String adId)? onAdLoaded;

  /// 广告展示成功回调
  final VoidCallback? onAdShown;

  /// 广告加载失败回调
  final Function(int errorCode)? onAdFailed;

  /// 广告关闭回调
  final VoidCallback? onAdClosed;

  /// 广告视图关闭回调
  final VoidCallback? onAdClosedView;

  /// 广告被点击回调
  final VoidCallback? onAdClicked;

  BeiZiNativeAdListener({
    this.onAdLoaded,
    this.onAdShown,
    this.onAdFailed,
    this.onAdClosed,
    this.onAdClosedView,
    this.onAdClicked,
  });
}

///组件关闭通知接口
typedef AdWidgetNeedCloseCall = void Function();
