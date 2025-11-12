import 'package:beizi_sdk/beizi_sdk_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/blurred_background.dart';
import 'widgets/button_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.title});

  final String title;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashAd? _splashAd;
  late SplashAdListener _adCallBack;
  num eCpm = 0;
  bool initSuccess = false;
  bool couldBack = true;

  @override
  void dispose() {
    super.dispose();
    _splashAd?.cancel();
  }
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    _adCallBack = SplashAdListener(onAdLoaded: () {
      _splashAd?.showAd();
    }, onAdFailedToLoad: (errorCode) {
      debugPrint("请求广告失败=$errorCode");
    }, onAdShown: (){
      debugPrint("广告展示");
    }, onAdClicked: (){
      debugPrint("广告点击");
    }, onAdClosed: (){
      debugPrint("广告关闭");
    });
    _splashAd = SplashAd(
        adSpaceId: '104835',
        totalTime: 5000,
        listener: _adCallBack);
    // 使用命名路由跳转
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 此时可以安全获取 MediaQuery 信息
      var width = MediaQuery.of(context).size.width.toInt();
      var height = MediaQuery.of(context).size.height.toInt();
      _splashAd?.loadAd(
          width: width,
          height: height - 100,
          splashBottomWidget: SplashBottomWidget(
              height: 100,
              backgroundColor: "#FFFFFFFF",
              children: [
                ImageComponent(
                  width: 25,
                  height: 25,
                  x: 170,
                  y: 10,
                  imagePath: 'assets/images/img.png',
                ),
                TextComponent(
                  fontSize: 24,
                  color: "#00ff00",
                  x: 140,
                  y: 50,
                  text: 'Hello Android!',
                ),
              ]));
    });

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: couldBack,
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const BlurredBackground(),
                Column(
                  children: [
                    const SizedBox(height: 100, width: 0),
                    ButtonWidget(
                        buttonText: '点击加载开屏页面',
                        callBack: () {
                          _splashAd = SplashAd(
                              adSpaceId: '104835',
                              totalTime: 5000,
                              listener: _adCallBack);
                          var width = MediaQuery.of(context).size.width.toInt();
                          var height = MediaQuery.of(context).size.height.toInt();
                          _splashAd?.loadAd(
                              width: width,
                              height: height - 100,
                              splashBottomWidget: SplashBottomWidget(
                                  height: 100,
                                  backgroundColor: "#FFFFFFFF",
                                  children: [
                                    ImageComponent(
                                      width: 25,
                                      height: 25,
                                      x: 170,
                                      y: 10,
                                      imagePath: 'assets/images/img.png',
                                    ),
                                    TextComponent(
                                      fontSize: 24,
                                      color: "#00ff00",
                                      x: 140,
                                      y: 50,
                                      text: 'Hello Android!',
                                    ),
                                  ]));
                        }),
                    ButtonWidget(
                        buttonText: '获取竞价=$eCpm',
                        callBack: () async {
                          _splashAd?.getECPM().then((ecPmResult) {
                            setState(() {
                              eCpm = ecPmResult;
                            });
                          });
                        }),
                    ButtonWidget(
                        buttonText: '上报竞胜',
                        callBack: () async {
                          Map<String, String> map = {
                            BeiZiBiddingConstant.winPriceKey: "10",
                            BeiZiBiddingConstant.highestLossPriceKey: "9",
                            BeiZiBiddingConstant.adnIdKey: BeiZiAdn.adnBz
                          };
                          _splashAd?.sendWinNotificationWithInfo(map);
                        }),
                    ButtonWidget(
                        buttonText: '上报竞价失败',
                        callBack: () async {
                          Map<String, String> map = {
                            BeiZiBiddingConstant.winPriceKey: "10",
                            BeiZiBiddingConstant.adnIdKey: BeiZiAdn.adnBz,
                            BeiZiBiddingConstant.lossReasonKey:
                                BeiZiLossReason.lowPrice
                          };
                          _splashAd?.sendLossNotificationWithInfo(map);
                        }),
                  ],
                )
              ],
            )));
  }
}
