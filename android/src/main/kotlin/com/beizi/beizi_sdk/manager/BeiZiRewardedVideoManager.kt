package com.beizi.beizi_sdk.manager

import com.beizi.beizi_sdk.data.BeiZiRewardVideoKeys
import com.beizi.beizi_sdk.data.BeiZiRewardedVideoAdChannelMethod
import com.beizi.beizi_sdk.data.BeiZiSdkMethodNames
import com.beizi.beizi_sdk.utils.FlutterPluginUtil
import com.beizi.fusion.RewardedVideoAd
import com.beizi.fusion.RewardedVideoAdListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

/**
 * 插屏广告管理器 (单例)
 * 负责处理来自 Flutter 的方法调用
 */
class BeiZiRewardedVideoManager private constructor() {
    private var rewardedVideoAd: RewardedVideoAd? = null

    companion object {
        @Volatile
        private var instance: BeiZiRewardedVideoManager? = null

        fun getInstance(): BeiZiRewardedVideoManager {
            return instance ?: synchronized(this) {
                instance ?: BeiZiRewardedVideoManager().also { instance = it }
            }
        }
    }

    private val adCallback = object : RewardedVideoAdListener {
        override fun onRewarded() {
            sendMessage(BeiZiRewardedVideoAdChannelMethod.ON_REWARDED)
        }

        override fun onRewardedVideoAdFailedToLoad(p0: Int) {
            sendMessage(
                BeiZiRewardedVideoAdChannelMethod.ON_REWARDED_VIDEO_AD_FAILED_TO_LOAD,
                p0
            )
        }

        override fun onRewardedVideoAdLoaded() {
            sendMessage(BeiZiRewardedVideoAdChannelMethod.ON_REWARDED_VIDEO_AD_LOADED)
        }

        override fun onRewardedVideoCacheSuccess() {
            sendMessage(BeiZiRewardedVideoAdChannelMethod.ON_REWARDED_VIDEO_CACHE_SUCCESS)
        }

        override fun onRewardedVideoAdShown() {
            sendMessage(BeiZiRewardedVideoAdChannelMethod.ON_REWARDED_VIDEO_AD_SHOWN)
        }

        override fun onRewardedVideoAdClosed() {
            sendMessage(BeiZiRewardedVideoAdChannelMethod.ON_REWARDED_VIDEO_AD_CLOSED)
        }

        override fun onRewardedVideoClick() {
            sendMessage(BeiZiRewardedVideoAdChannelMethod.ON_REWARDED_VIDEO_CLICK)
        }

        override fun onRewardedVideoComplete() {
            sendMessage(BeiZiRewardedVideoAdChannelMethod.ON_REWARDED_VIDEO_COMPLETE)
        }

        override fun onRewardedVideoPlayError() {
            sendMessage(BeiZiRewardedVideoAdChannelMethod.ON_REWARDED_VIDEO_PLAY_ERROR)
        }
    }

    fun handleMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            BeiZiSdkMethodNames.REWARDED_VIDEO_CREATE -> createAd(call, result)
            BeiZiSdkMethodNames.REWARDED_VIDEO_LOAD -> handleRewardedVideoLoad(call, result)
            BeiZiSdkMethodNames.REWARDED_VIDEO_SHOW_AD -> handleRewardedVideoShowAd(call, result)
            BeiZiSdkMethodNames.REWARDED_VIDEO_IS_LOADED -> {
                result.success(rewardedVideoAd?.isLoaded ?: false)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_GET_USERID -> {
                result.success(rewardedVideoAd?.userId)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_SET_USERID -> {
                val userId = call.arguments as? String
                if (userId != null) {
                    rewardedVideoAd?.userId = userId
                }
                result.success(null)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_GET_ECPM -> {
                result.success(rewardedVideoAd?.ecpm ?: 0)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_NOTIFY_RTB_WIN -> {
                rewardedVideoAd?.sendWinNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_NOTIFY_RTB_LOSS -> {
                rewardedVideoAd?.sendLossNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_GET_EXTRA -> {
                result.success(rewardedVideoAd?.extra)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_SET_EXTRA -> {
                val extra = call.arguments as? String
                if (extra != null) {
                    rewardedVideoAd?.extra = extra
                }
                result.success(null)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_GET_CUSTOM_EXT_DATA -> {
                result.success(rewardedVideoAd?.customExtraData)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_GET_CUSTOM_JSON_DATA -> {
                result.success(rewardedVideoAd?.customExtraJsonData)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_SET_BID_RESPONSE -> {
                rewardedVideoAd?.setBidResponse(call.arguments as String)
                result.success(null)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_SET_SPACE_PARAM -> {
                if (call.arguments != null && call.arguments is Map<*, *>) {
                    @Suppress("UNCHECKED_CAST")
                    val params = call.arguments as Map<String, Any>
                    rewardedVideoAd?.setSpaceParam(params)
                }
                result.success(null)
            }

            BeiZiSdkMethodNames.REWARDED_VIDEO_DESTROY -> {
                rewardedVideoAd?.apply {
                    destroy()
                }
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun createAd(
        call: MethodCall,
        result: Result
    ) {
        val activity = FlutterPluginUtil.getActivity()
        if (activity == null) {
            result.error("LOAD_FAILED", "Activity not available for loading splash ad.", null)
            return
        }
        val adOptionsMap = call.arguments<Map<String, Any>?>()
        val mSpaceId: String? = adOptionsMap?.get(BeiZiRewardVideoKeys.AD_SPACE_ID) as String?
        val mTimeout: Int = adOptionsMap?.get(BeiZiRewardVideoKeys.TOTAL_TIME) as Int? ?: 10000
        val modeType: Int = adOptionsMap?.get(BeiZiRewardVideoKeys.MODEL_TYPE) as Int? ?: 1
        rewardedVideoAd =
            RewardedVideoAd(activity, mSpaceId, adCallback, mTimeout.toLong(), modeType)
        result.success(null)
    }

    private fun handleRewardedVideoLoad(call: MethodCall, result: Result) {
        try {
            rewardedVideoAd?.loadAd()
            result.success(true)
        } catch (e: Exception) {
            result.error("LOAD_EXCEPTION", "Error loading Rewarded ad: ${e.message}", e.toString())
        }
    }

    private fun handleRewardedVideoShowAd(call: MethodCall, result: Result) {
        val activity = FlutterPluginUtil.getActivity()
        if (rewardedVideoAd == null) {
            result.error("SHOW_FAILED", "Rewarded ad not loaded.", null)
            return
        }
        activity?.let { activity ->
            rewardedVideoAd?.apply {
                if (isLoaded) {
                    showAd(activity)
                    result.success(null)
                } else {
                    result.error("-1000", "ad not isLoaded", "Rewarded not loaded")
                }
            }
        }
    }

    private fun sendMessage(method: String, args: Any? = null) {
        BeiZiEventManager.getInstance().sendMessageToFlutter(method, args)
    }
}
