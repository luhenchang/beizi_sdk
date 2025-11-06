package com.beizi.beizi_sdk.manager

import android.os.Build
import androidx.annotation.RequiresApi
import com.beizi.beizi_sdk.data.BeiZiSdkMethodNames
import com.beizi.beizi_sdk.data.BeiziInitKeys
import com.beizi.fusion.BeiZis
import com.beizi.beizi_sdk.utils.BeiZiCustomControllerUtil
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class BeiZiSDKInitManager private constructor() {

    companion object {
        @Volatile
        private var instance: BeiZiSDKInitManager? = null

        fun getInstance(): BeiZiSDKInitManager {
            return instance ?: synchronized(this) {
                instance ?: BeiZiSDKInitManager().also { instance = it }
            }
        }
    }


    fun handleMethodCall(call: MethodCall, result: Result) {
        if (call.method != BeiZiSdkMethodNames.INIT) {
            result.notImplemented()
            return
        }
        val context = BeiZiEventManager.getInstance().getContext()
        val flutterParams = call.arguments as? Map<*, *>
        if (context == null || flutterParams == null) {
            result.error("INITIALIZATION_FAILED", "Context or arguments are missing.", null)
            return
        }
        val appId = flutterParams[BeiziInitKeys.APP_ID] as? String
        if (appId.isNullOrEmpty()) {
            result.error("INVALID_ARGUMENT", "appId is missing or empty.", null)
            return
        }
        val controller = BeiZiCustomControllerUtil.createControllerFromMap(flutterParams)
        BeiZis.init(context, appId, controller)
        (flutterParams[BeiziInitKeys.IS_PERSONAL_RECOMMEND] as? Boolean)?.let { isPersonalRecommend ->
            BeiZis.setLimitPersonalAds(isPersonalRecommend)
        }
        result.success(true)
    }

}
