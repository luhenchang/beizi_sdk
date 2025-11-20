//调试-安卓-APP ID:20826 ，广告位ID：
// 开屏：104835、原生（小图，左文右图）：
// 106064、原生（大图）：106080  、
// 竖版插屏：106981、
// 激励视频：111366
//
//调试-IOS-APPID：20825 、调试-IOS-广告位ID：开屏：104833 、原生：106043 、自渲染：106063 、插屏：107249、激励视频：111367
//
//这是配套使用的测试ID。先用这套ID调试，调试好给我们发个测试包看看，没问题的话我们会提供正式ID替换
//
//http://sdkdoc.beizi.biz/#/

import 'dart:io';

var appId = Platform.isAndroid ? "20826" : "20825";
var splashSpaceId = Platform.isAndroid ? '104835' : "104833";
var interstitialSpaceId = Platform.isAndroid ? '106981' : "107249";
var nativeSpaceId = Platform.isAndroid ? '106064' : "106043";
var unifiedSpaceId = Platform.isAndroid ? '106064' : "106063";
var rewardVideoSpaceId = Platform.isAndroid ? '111366' : "111367";
var timeOut = 5000; //广告请求超时时长，建议5000毫秒,该参数单位为ms
