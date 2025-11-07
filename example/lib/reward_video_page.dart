import 'package:beizi_sdk/beizi_sdk_export.dart';
import 'package:beizi_sdk/controller/beizi_reward_video_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RewardedVideoPage extends StatefulWidget {
  const RewardedVideoPage({super.key, required this.title});

  final String title;

  @override
  State<RewardedVideoPage> createState() => _RewardedVideoPageState();
}

class _RewardedVideoPageState extends State<RewardedVideoPage> {
  late RewardedVideoAdListener _adCallBack;
  RewardedVideoAd? _rewardedAd;
  bool couldBack = true;
  num eCpm = 0;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    _adCallBack = RewardedVideoAdListener(onRewarded: (){

    },onRewardedVideoAdLoaded: () {
      _rewardedAd?.isLoaded().then((loaded){
        if(loaded) {
          _rewardedAd?.showAd();
        }
      });
    });
    _rewardedAd = RewardedVideoAd(listener: _adCallBack, adSpaceId: '111366', totalTime: 15000);
  }

  @override
  void dispose() {
    _rewardedAd?.destroy();
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
                    child: const Text('点击展示激励视频'),
                    onPressed: () {
                      _rewardedAd = RewardedVideoAd(listener: _adCallBack, adSpaceId: '111366', totalTime: 15000);
                      // 返回上一页
                      _rewardedAd?.loadAd();
                    },
                  )
                ]),
              ],
            )));
  }
}
