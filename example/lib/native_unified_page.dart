import 'package:beizi_sdk/beizi_sdk_export.dart';
import 'package:beizi_sdk/data/beizi_unified_native_listener.dart';
import 'package:flutter/material.dart';

import 'union_download_app_info_page.dart';

class NativeUnifiedPage extends StatefulWidget {
  const NativeUnifiedPage({super.key, required this.title});

  final String title;

  @override
  State<NativeUnifiedPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<NativeUnifiedPage> {
  late BeiZiUnifiedNativeAdListener _adCallBack;
  BeiZiUnifiedNativeAd? _nativeAd;
  List<String> feedList = [];
  List<String> feedAdList = [];
  late double expressWidth = 350;
  late double expressHeight = 128;
  UnifiedAdDownloadAppInfo? downLoadAppInfo;
  int materialType = 0;
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 30; i++) {
      feedList.add("item name =$i");
    }
    setState(() {});
    _adCallBack = BeiZiUnifiedNativeAdListener(
        onAdLoaded: (adId) {
          setState(() {
            _nativeAd?.getMaterialType(adId).then((type){
              debugPrint("materialType=$type");
              setState(() {
                materialType = type;
              });
            });
            _nativeAd?.getDownLoadInfo(adId).then((info) {
              if (info != null) {
                setState(() {
                  debugPrint("info===${info.appName}");
                  downLoadAppInfo = info;
                });
              }
            });
            feedAdList.add(adId);
          });
        },
        onAdClosed: (adId) {
          setState(() {
            //feedAdList.remove(adId);
          });
        },
        onAdClicked: () {},
        onAdFailed: (errorCode) {},
        onAdShown: () {});
    _nativeAd = BeiZiUnifiedNativeAd(
        adSpaceId: '106064',
        totalTime: 15000,
        expressSize: [expressWidth, expressHeight],
        listener: _adCallBack);
    const Map<String, bool> map = {
      "HideAdLogo": false,
      "HideDownloadInfo": false
    };
    _nativeAd?.setHide(map);
    _nativeAd?.loadAd();
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
              return SizedBox.fromSize(
                size: Size(expressWidth, expressHeight),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    UnifiedWidget(
                      _nativeAd,
                      key: ValueKey(adId),
                      adId: adId,
                      unifiedContent: NativeUnifiedWidget(
                          height: expressHeight,
                          backgroundColor: '#F0EDF4',
                          children: [
                            if(materialType == 1)
                            UnifiedMainImgWidget(
                                width: expressWidth,
                                height: expressHeight,
                                x: 0,
                                y: 0,
                                backgroundColor: '#FFFFFF',
                                clickType: AMPSAdItemClickType.click),
                            if(materialType == 2)
                            UnifiedVideoWidget(
                                width: 100, height: 0, x: 200, y: 0),
                            UnifiedTitleWidget(
                                fontSize: 16,
                                color: "#FFFFFF",
                                x: 5,
                                y: 5,
                                clickType: AMPSAdItemClickType.click),
                            UnifiedDescWidget(
                                fontSize: 16,
                                width: 200,
                                color: "#FFFFFF",
                                x: 5,
                                y: 30),
                            UnifiedActionButtonWidget(
                                fontSize: 12,
                                width: 50,
                                height: 20,
                                fontColor: '#FF00FF',
                                backgroundColor: '#FFFF33',
                                x: 270,
                                y: 80),
                            UnifiedAppIconWidget(
                                width: 25, height: 25, x: 320, y: 100),
                            // UnifiedCloseWidget(
                            //     imagePath: 'assets/images/close.png',
                            //     width: 16,
                            //     height: 16,
                            //     x: 330,
                            //     y: 5)
                          ]),
                    ),
                    Positioned(
                      top: 8,
                      right: 26,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              feedAdList.remove(adId);
                            });
                          },
                          borderRadius: BorderRadius.circular(16), // 水波纹圆角
                          child: Image.asset('assets/images/close.png',
                              width: 18, height: 18)),
                    ),
                    if (downLoadAppInfo != null &&
                        downLoadAppInfo?.appName != null)
                      Positioned(
                        left: 28,
                        top: 100,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, 'UnionDownloadAppInfoPage',
                                arguments: AppInfoArguments(
                                  titleContent: downLoadAppInfo?.appName ?? "",
                                  permissionContent: downLoadAppInfo?.appPermission ?? "",
                                  privacyContent: downLoadAppInfo?.appPrivacy ?? "",
                                  introContent: downLoadAppInfo?.appIntro ?? "",
                                ).toMap());
                          },
                          borderRadius: BorderRadius.circular(16), // 水波纹圆角
                          child: Text(
                              "应用名称：${downLoadAppInfo?.appName} | 开发者：${downLoadAppInfo?.appDeveloper}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  backgroundColor: Colors.white)),
                        ),
                      )
                  ],
                ),
              );
            }
            return Column(
              children: [
                const Divider(height: 5, color: Colors.white),
                Container(
                  height: 128,
                  width: 350,
                  color: Colors.blueAccent,
                  alignment: Alignment.centerLeft,
                  child: Text('List item ${feedList[feedIndex]}'),
                ),
                if (index % 5 == 3 && adIndex < feedAdList.length)
                  const Divider(height: 5, color: Colors.white)
              ],
            );
          },
        ));
  }
}
