import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../common.dart';
import '../controller/beizi_native_ad.dart';

class NativeWidget extends StatefulWidget {
  // 返回的广告 id，这里不是广告位id
  final String adId;
  final BeiZiNativeAd? adNative;

  const NativeWidget(this.adNative, {super.key, required this.adId});

  @override
  State<StatefulWidget> createState() => _NativeWidgetState();
}

class _NativeWidgetState extends State<NativeWidget>
    with AutomaticKeepAliveClientMixin {
  /// 创建参数
  late Map<String, dynamic> creationParams;

  /// 宽高
  double width = 375, height = 128;
  bool widgetNeedClose = false;

  @override
  void initState() {
    var adWidth = widget.adNative?.adWidth;
    var adHeight = widget.adNative?.adHeight;
    if (adWidth != null) {
      width = adWidth;
    }
    if (adHeight != null) {
      height = adHeight;
    }
    creationParams = <String, dynamic>{
      "native_adId": widget.adId,
      "width": width,
      "height": height
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (width <= 0 || height <= 0 || widgetNeedClose) {
      return const SizedBox.shrink();
    }
    Widget view;
    if (Platform.isAndroid) {
      view = AndroidView(
          viewType: BeiZiPlatformViewRegistry.beiZiSdkNativeViewId,
          creationParams: creationParams,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec());
    } else if (Platform.isIOS) {
      view = UiKitView(
          viewType: BeiZiPlatformViewRegistry.beiZiSdkNativeViewId,
          creationParams: creationParams,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec());
    }
    // else if (Platform.isOhos) {
    //   view =  OhosView(
    //       viewType: AMPSPlatformViewRegistry.ampsSdkNativeViewId,
    //       onPlatformViewCreated: _onPlatformViewCreated,
    //       creationParams: creationParams,
    //       creationParamsCodec: const StandardMessageCodec());
    // }
    else {
      view = const Center(child: Text("暂不支持此平台"));
    }

    /// 有宽高信息了（渲染成功了）设置对应宽高
    return SizedBox.fromSize(
      size: Size(width, height),
      child: view,
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onPlatformViewCreated(int id) {
    widget.adNative?.setAdCloseCallBack(() {
      setState(() {
        widgetNeedClose = true;
      });
    });
  }
}
