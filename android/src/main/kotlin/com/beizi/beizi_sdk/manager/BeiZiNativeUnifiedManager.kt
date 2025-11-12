package com.beizi.beizi_sdk.manager

import android.app.Activity
import com.beizi.beizi_sdk.data.BeiZiNativeUnifiedAdChannelMethod
import com.beizi.beizi_sdk.data.BeiZiNativeUnifiedKeys
import com.beizi.beizi_sdk.data.BeiZiSdkMethodNames
import com.beizi.fusion.NativeUnifiedAd
import com.beizi.fusion.NativeUnifiedAdListener
import com.beizi.fusion.NativeUnifiedAdResponse
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.util.UUID
import kotlin.collections.mapOf

class BeiZiNativeUnifiedManager {
    private var mNativeUnifiedAd: NativeUnifiedAd? = null
    private var currentActivityRef: WeakReference<Activity>? =
        WeakReference(BeiZiEventManager.getInstance().getContext())

    private fun getCurrentActivity(): Activity? = currentActivityRef?.get()

    private val nativeAdListener = object : NativeUnifiedAdListener {

        override fun onAdFailed(code: Int) {
            sendMessage(BeiZiNativeUnifiedAdChannelMethod.ON_AD_FAILED, code)
        }

        override fun onAdLoaded(adResponse: NativeUnifiedAdResponse?) {
            val uniqueId = UUID.randomUUID().toString().replace("-", "")
            adResponse?.let { response ->
                AdResponseManager.getInstance().addAdResponse(uniqueId, adResponse)
            }
            sendMessage(BeiZiNativeUnifiedAdChannelMethod.ON_AD_LOADED, uniqueId)
        }


        override fun onAdShown() {
            sendMessage(BeiZiNativeUnifiedAdChannelMethod.ON_AD_SHOWN)
        }


        override fun onAdClick() {
            sendMessage(BeiZiNativeUnifiedAdChannelMethod.ON_AD_CLICK)
        }
    }

    companion object {
        @Volatile
        private var instance: BeiZiNativeUnifiedManager? = null

        fun getInstance(): BeiZiNativeUnifiedManager {
            return instance ?: synchronized(this) {
                instance ?: BeiZiNativeUnifiedManager().also { instance = it }
            }
        }
    }

    fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            BeiZiSdkMethodNames.NATIVE_UNIFIED_CREATE -> createAd(call, result)

            BeiZiSdkMethodNames.NATIVE_UNIFIED_SET_HIDE -> {
                call.arguments?.let { hideMap ->
                    val map = (hideMap as Map<String, Boolean>)
                    map[BeiZiNativeUnifiedKeys.HIDE_AD_LOGO]?.let {
                        //隐藏广告角标
                        mNativeUnifiedAd?.setHideAdLogo(it)
                    }
                    map[BeiZiNativeUnifiedKeys.HIDE_DOWNLOAD_INFO]?.let {
                        //隐藏下载类广告六要素
                        mNativeUnifiedAd?.setHideDownloadInfo(it)
                    }

                }

            }


            BeiZiSdkMethodNames.NATIVE_UNIFIED_LOAD -> handleNativeLoad(call, result)

            BeiZiSdkMethodNames.NATIVE_UNIFIED_GET_DOWNLOAD -> {
                val adId = call.arguments
                if (adId != null && adId is String) {
                    val infoMap: Map<String, String?> = mapOf(
                        "appName" to ("抖音"),
                        "appVersion" to ("5.1.3"),
                        "appDeveloper" to ("斗哥"),
                        "appPermission" to ("权限列表内容比较清晰。了老师浪费精力联赛附加赛浪费精力十六分零四分类"),
                        "appPrivacy" to ("零四点零分十六六十六分十六地方六十六的饭"),
                        "appIntro" to ("抖音作为世界上最大的短视频代表真的厉害了"),
                    )
                    result.success(infoMap)
                    return
                    AdResponseManager.getInstance()
                        .getAdResponse(adId)?.downloadAppInfo?.let { info ->
//                            val infoMap: Map<String, String?> = mapOf(
//                                "appName" to (info?.appName?:"抖音"),
//                                "appVersion" to (info?.appVersion?:"5.1.3"),
//                                "appDeveloper" to info?.appDeveloper,
//                                "appPermission" to info?.appPermission,
//                                "appPrivacy" to info?.appPrivacy,
//                                "appIntro" to info?.appIntro,
//                            )
                            val infoMap: Map<String, String?> = mapOf(
                                "appName" to (info.appName?:"抖音"),
                                "appVersion" to (info.appVersion?:"5.1.3"),
                                "appDeveloper" to (info.appDeveloper?:"斗哥"),
                                "appPermission" to (info.appPermission?:"权限列表内容比较清晰。了老师浪费精力联赛附加赛浪费精力十六分零四分类"),
                                "appPrivacy" to (info.appPrivacy?:"零四点零分十六六十六分十六地方六十六的饭"),
                                "appIntro" to (info.appIntro?:"抖音作为世界上最大的短视频代表真的厉害了"),
                            )
                            result.success(infoMap)
                            return
                        }
                }
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_RESUME -> {
                mNativeUnifiedAd?.resume()
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_GET_ECPM -> {
                result.success(mNativeUnifiedAd?.ecpm ?: 0)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_DESTROY -> {
                mNativeUnifiedAd?.apply {
                    AdResponseManager.getInstance().clearAllAdsResponse()
                    destroy()
                }
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_GET_CUSTOM_EXT_DATA -> {
                result.success(mNativeUnifiedAd?.customExtraData)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_GET_CUSTOM_JSON_DATA -> {
                result.success(mNativeUnifiedAd?.customExtraJsonData)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_NOTIFY_RTB_WIN -> {
                mNativeUnifiedAd?.sendWinNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_NOTIFY_RTB_LOSS -> {
                mNativeUnifiedAd?.sendLossNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_SET_BID_RESPONSE -> {
                mNativeUnifiedAd?.setBidResponse(call.arguments as String)
                result.success(null)
            }

            BeiZiSdkMethodNames.NATIVE_UNIFIED_SET_SPACE_PARAM -> {
                if (call.arguments != null && call.arguments is Map<*, *>) {
                    @Suppress("UNCHECKED_CAST")
                    val params = call.arguments as Map<String, Any>
                    mNativeUnifiedAd?.setSpaceParam(params)
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
        val mSpaceId: String? = adOptionsMap?.get(BeiZiNativeUnifiedKeys.AD_SPACE_ID) as String?
        val mTimeout: Int = adOptionsMap?.get(BeiZiNativeUnifiedKeys.TOTAL_TIME) as Int? ?: 5000
        val modeType: Int = adOptionsMap?.get(BeiZiNativeUnifiedKeys.MODEL_TYPE) as Int? ?: 1
        mNativeUnifiedAd =
            NativeUnifiedAd(activity, mSpaceId, nativeAdListener, mTimeout.toLong(), modeType)
        result.success(null)
    }

    private fun handleNativeLoad(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        try {
            mNativeUnifiedAd?.loadAd()
            result.success(true)
        } catch (e: Exception) {
            result.error("LOAD_EXCEPTION", "Error loading splash ad: ${e.message}", e.toString())
        }
    }

    private fun sendMessage(method: String, args: Any? = null) {
        BeiZiEventManager.getInstance().sendMessageToFlutter(method, args)
    }
}