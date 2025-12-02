package com.beizi.beizi_sdk.manager

import android.app.Activity
import com.beizi.beizi_sdk.data.BeiZiInterAdCallBackMethod
import com.beizi.beizi_sdk.data.BeiZiInterKeys
import com.beizi.beizi_sdk.data.BeiZiSdkMethodNames
import com.beizi.beizi_sdk.utils.FlutterPluginUtil
import com.beizi.fusion.InterstitialAd
import com.beizi.fusion.InterstitialAdListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference

/**
 * 插屏广告管理器 (单例)
 * 负责处理来自 Flutter 的方法调用
 */
class BeiZiInterstitialManager private constructor() {
    private var interstitialAd: InterstitialAd? = null

    companion object {
        @Volatile
        private var instance: BeiZiInterstitialManager? = null

        fun getInstance(): BeiZiInterstitialManager {
            return instance ?: synchronized(this) {
                instance ?: BeiZiInterstitialManager().also { instance = it }
            }
        }
    }


    private val adCallback = object : InterstitialAdListener {

        override fun onAdFailed(p0: Int) {
            sendMessage(BeiZiInterAdCallBackMethod.ON_AD_FAILED, p0)
        }

        override fun onAdLoaded() {
            sendMessage(BeiZiInterAdCallBackMethod.ON_AD_LOADED)
        }

        override fun onAdShown() {
            sendMessage(BeiZiInterAdCallBackMethod.ON_AD_SHOWN)
        }

        override fun onAdClosed() {
            sendMessage(BeiZiInterAdCallBackMethod.ON_AD_CLOSED)
        }

        override fun onAdClick() {
            sendMessage(BeiZiInterAdCallBackMethod.ON_AD_CLICKED)
        }
    }

    fun handleMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            BeiZiSdkMethodNames.INTERSTITIAL_CREATE -> createAd(call, result)
            BeiZiSdkMethodNames.INTERSTITIAL_SET_AD_VERSION -> {
                val adVersion = call.arguments
                if (adVersion is Int) {
                    interstitialAd?.setAdVersion(adVersion)
                }
            }
            BeiZiSdkMethodNames.INTERSTITIAL_LOAD -> handleSplashLoad(call, result)
            BeiZiSdkMethodNames.INTERSTITIAL_SHOW_AD -> handleSplashShowAd(call, result)
            BeiZiSdkMethodNames.INTERSTITIAL_IS_LOADED -> {
                result.success(interstitialAd?.isLoaded ?: false)
            }

            BeiZiSdkMethodNames.INTERSTITIAL_GET_ECPM -> {
                result.success(interstitialAd?.ecpm ?: 0)
            }

            BeiZiSdkMethodNames.INTERSTITIAL_NOTIFY_RTB_WIN -> {
                interstitialAd?.sendWinNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.INTERSTITIAL_NOTIFY_RTB_LOSS -> {
                interstitialAd?.sendLossNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.INTERSTITIAL_GET_CUSTOM_EXT_DATA -> {
                result.success(interstitialAd?.customExtraData)
            }

            BeiZiSdkMethodNames.INTERSTITIAL_GET_CUSTOM_JSON_DATA -> {
                result.success(interstitialAd?.customExtraJsonData)
            }

            BeiZiSdkMethodNames.INTERSTITIAL_SET_BID_RESPONSE -> {
                interstitialAd?.setBidResponse(call.arguments as String)
                result.success(null)
            }

            BeiZiSdkMethodNames.INTERSTITIAL_SET_SPACE_PARAM -> {
                if (call.arguments != null && call.arguments is Map<*, *>) {
                    @Suppress("UNCHECKED_CAST")
                    val params = call.arguments as Map<String, Any>
                    interstitialAd?.setSpaceParam(params)
                }
                result.success(null)
            }

            BeiZiSdkMethodNames.INTERSTITIAL_DESTROY -> {
                interstitialAd?.apply {
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
        val mSpaceId: String? = adOptionsMap?.get(BeiZiInterKeys.AD_SPACE_ID) as String?
        val mTimeout: Int = adOptionsMap?.get(BeiZiInterKeys.TOTAL_TIME) as Int? ?: 5000
        val modeType: Int? = adOptionsMap?.get(BeiZiInterKeys.MODEL_TYPE) as Int?
        interstitialAd = if (modeType == null) {
            InterstitialAd(activity, mSpaceId, adCallback, mTimeout.toLong())
        } else {
            InterstitialAd(activity, mSpaceId, adCallback, mTimeout.toLong(), modeType)
        }
        result.success(null)
    }

    private fun handleSplashLoad(call: MethodCall, result: Result) {
        try {
            interstitialAd?.loadAd()
            result.success(true)
        } catch (e: Exception) {
            result.error("LOAD_EXCEPTION", "Error loading splash ad: ${e.message}", e.toString())
        }
    }

    private fun handleSplashShowAd(call: MethodCall, result: Result) {
        val activity = FlutterPluginUtil.getActivity()
        if (interstitialAd == null) {
            result.error("SHOW_FAILED", "InterstitiaAd ad not loaded.", null)
            return
        }
        activity?.let { activity ->
            interstitialAd?.apply {
                if (isLoaded) {
                    showAd(activity)
                    result.success(null)
                } else {
                    result.error("-1000", "ad not isLoaded", "interstitialAd not loaded")
                }
            }
        }
    }

    private fun sendMessage(method: String, args: Any? = null) {
        BeiZiEventManager.getInstance().sendMessageToFlutter(method, args)
    }
}
