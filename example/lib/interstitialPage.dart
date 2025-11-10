import 'package:beizi_sdk/beizi_sdk_export.dart';
import 'package:flutter/material.dart';

class InterstitialPage extends StatefulWidget {
  const InterstitialPage({super.key, required this.title});

  final String title;

  @override
  State<InterstitialPage> createState() => _InterstitialPageState();
}

class _InterstitialPageState extends State<InterstitialPage> {
  late InterstitialAdListener _adCallBack;
  InterstitialAd? _interAd;
  bool couldBack = true;
  num eCpm = 0;

  @override
  void initState() {
    super.initState();
    _adCallBack = InterstitialAdListener(
        onAdLoaded: () {
          _interAd?.isLoaded().then((isLoaded){
            _interAd?.showAd();
          });
        },
        onAdClosed: () {},
        onAdFailed: (code) {},
        onAdClick: () {},
        onAdShown: () {});
    _interAd =
        InterstitialAd(listener: _adCallBack, adSpaceId: '106981', totalTime: 5000);
  }

  @override
  void dispose() {
    _interAd?.destroy();
    super.dispose();
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
              children: [
                Column(children: [
                  ElevatedButton(
                    child: const Text('点击展示插屏'),
                    onPressed: () {
                      _interAd = InterstitialAd(
                          listener: _adCallBack,
                          adSpaceId: '106981',
                          totalTime: 5000);
                      // 返回上一页
                      _interAd?.loadAd();
                    },
                  )
                ]),
              ],
            )));
  }
}
