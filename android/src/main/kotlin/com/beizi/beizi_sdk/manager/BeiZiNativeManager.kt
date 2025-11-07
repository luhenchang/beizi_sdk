package com.beizi.beizi_sdk.manager

import android.app.Activity
import android.view.View
import com.beizi.beizi_sdk.data.BeiZiNativeAdChannelMethod
import com.beizi.beizi_sdk.data.BeiZiNativeKeys
import com.beizi.beizi_sdk.data.BeiZiSdkMethodNames
import com.beizi.fusion.NativeAd
import com.beizi.fusion.NativeAdListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.util.UUID

class BeiZiNativeManager {
    private var mNativeAd: NativeAd? = null
    private var currentActivityRef: WeakReference<Activity>? =
        WeakReference(BeiZiEventManager.getInstance().getContext())

    private fun getCurrentActivity(): Activity? = currentActivityRef?.get()

    private val nativeAdListener = object : NativeAdListener {

        override fun onAdFailed(code: Int) {
            sendMessage(BeiZiNativeAdChannelMethod.ON_AD_FAILED, code)
        }

        override fun onAdLoaded(adView: View?) {
            val uniqueId = UUID.randomUUID().toString().replace("-", "")
            adView?.let { view ->
                AdViewManager.getInstance().addAdView(uniqueId, view)
            }
            sendMessage(BeiZiNativeAdChannelMethod.ON_AD_LOADED, uniqueId)
        }

        override fun onAdShown() {
            sendMessage(BeiZiNativeAdChannelMethod.ON_AD_SHOWN)
        }

        override fun onAdClosed() {
            AdViewManager.getInstance().clearAllAdsView()
            sendMessage(BeiZiNativeAdChannelMethod.ON_AD_CLOSED)
        }

        override fun onAdClosed(p0: View?) {
            AdViewManager.getInstance().clearAllAdsView()
            sendMessage(BeiZiNativeAdChannelMethod.ON_AD_CLOSED_VIEW)
        }

        override fun onAdClick() {
            sendMessage(BeiZiNativeAdChannelMethod.ON_AD_CLICK)
        }
    }

    companion object {
        @Volatile
        private var instance: BeiZiNativeManager? = null

        fun getInstance(): BeiZiNativeManager {
            return instance ?: synchronized(this) {
                instance ?: BeiZiNativeManager().also { instance = it }
            }
        }
    }

    fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            BeiZiSdkMethodNames.NATIVE_CREATE -> createAd(call, result)

            BeiZiSdkMethodNames.NATIVE_LOAD -> handleNativeLoad(call, result)

            BeiZiSdkMethodNames.NATIVE_RESUME -> {
                mNativeAd?.resume()
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_PAUSE -> {
                mNativeAd?.pause()
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_GET_ECPM -> {
                result.success(mNativeAd?.ecpm ?: 0)
            }

            BeiZiSdkMethodNames.NATIVE_DESTROY -> {
                mNativeAd?.apply {
                    AdViewManager.getInstance().clearAllAdsView()
                    destroy()

                }
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_GET_CUSTOM_EXT_DATA -> {
                result.success(mNativeAd?.customExtraData)
            }

            BeiZiSdkMethodNames.NATIVE_GET_CUSTOM_JSON_DATA -> {
                result.success(mNativeAd?.customExtraJsonData)
            }

            BeiZiSdkMethodNames.NATIVE_NOTIFY_RTB_WIN -> {
                mNativeAd?.sendWinNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_NOTIFY_RTB_LOSS -> {
                mNativeAd?.sendLossNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_SET_BID_RESPONSE -> {
                mNativeAd?.setBidResponse(call.arguments as String)
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_SET_SPACE_PARAM -> {
                if (call.arguments != null && call.arguments is Map<*, *>) {
                    @Suppress("UNCHECKED_CAST")
                    val params = call.arguments as Map<String, Any>
                    mNativeAd?.setSpaceParam(params)
                }
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun createAd(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val activity = getCurrentActivity()
        if (activity == null) {
            result.error("LOAD_FAILED", "Activity not available for loading splash ad.", null)
            return
        }
        val adOptionsMap = call.arguments<Map<String, Any>?>()
        val mSpaceId: String? = adOptionsMap?.get(BeiZiNativeKeys.AD_SPACE_ID) as String?
        val mTimeout: Int = adOptionsMap?.get(BeiZiNativeKeys.TOTAL_TIME) as Int? ?: 5000
        val modeType: Int = adOptionsMap?.get(BeiZiNativeKeys.MODEL_TYPE) as Int? ?: 1
        mNativeAd = NativeAd(activity, mSpaceId, nativeAdListener, mTimeout.toLong(), modeType)
        result.success(null)
    }

    private fun handleNativeLoad(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        try {
            val adOptionsMap = call.arguments<Map<String, Any>?>()
            val mWidth: Double = adOptionsMap?.get(BeiZiNativeKeys.WIDTH) as Double? ?: 0.0
            val mHeight: Double = adOptionsMap?.get(BeiZiNativeKeys.HEIGHT) as Double? ?: 0.0
            mNativeAd?.loadAd(mWidth.toFloat(), mHeight.toFloat())
            result.success(true)
        } catch (e: Exception) {
            result.error("LOAD_EXCEPTION", "Error loading splash ad: ${e.message}", e.toString())
        }
    }

    private fun sendMessage(method: String, args: Any? = null) {
        BeiZiEventManager.getInstance().sendMessageToFlutter(method, args)
    }
}