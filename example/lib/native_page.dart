import 'package:beizi_sdk/beizi_sdk_export.dart';
import 'package:beizi_sdk/data/beizi_native_listener.dart';
import 'package:flutter/material.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key, required this.title});

  final String title;

  @override
  State<NativePage> createState() => _SplashPageState();
}

class _SplashPageState extends State<NativePage> with WidgetsBindingObserver{
  late BeiZiNativeAdListener _adCallBack;
  BeiZiNativeAd? _nativeAd;
  List<String> feedList = [];
  List<String> feedAdList = [];
  late double expressWidth = 350;
  late double expressHeight = 128;

  @override
  void initState() {
    super.initState();
    // 注册观察者
    WidgetsBinding.instance.addObserver(this);
    for (var i = 0; i < 30; i++) {
      feedList.add("item name =$i");
    }
    setState(() {});
    _adCallBack = BeiZiNativeAdListener(onAdLoaded: (adId){
      setState(() {
        feedAdList.add(adId);
      });
    });
    
    _nativeAd = BeiZiNativeAd(adSpaceId: '106064', totalTime: 10000, listener: _adCallBack);
    _nativeAd?.loadAd(width: expressWidth, height: expressHeight);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 监听生命周期状态变化
    switch (state) {
      case AppLifecycleState.resumed:
        _nativeAd?.resume();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _nativeAd?.pause();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
    }
  }

  @override
  void dispose() {
    debugPrint("页面关闭完成");
    _nativeAd?.destroy();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemCount: feedList.length + feedAdList.length, // 列表项总数
          itemBuilder: (BuildContext context, int index) {
            int adIndex = index ~/ 5;
            int feedIndex = index - adIndex;
            if (index % 5 == 4 && adIndex < feedAdList.length) {
              String adId = feedAdList[adIndex];
              debugPrint(adId);
              return NativeWidget(_nativeAd,
                  key: ValueKey(adId),
                  adId: adId);
            }
            return Center(
              child:Column(
                children: [
                  const Divider(height: 10,color: Colors.white),
                  Container(
                    height: expressHeight,
                    width: expressWidth,
                    color: Colors.blueAccent,
                    alignment: Alignment.centerLeft,
                    child: Text('List item ${feedList[feedIndex]}'),
                  ),
                  if(index % 5 == 3 && adIndex < feedAdList.length)
                  const Divider(height: 10,color: Colors.white),
                ],
              )
            );
          },
        ));
  }
}
