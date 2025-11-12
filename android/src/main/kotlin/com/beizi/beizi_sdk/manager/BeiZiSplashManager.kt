package com.beizi.beizi_sdk.manager

import android.annotation.SuppressLint
import android.app.Activity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.RelativeLayout
import com.beizi.beizi_sdk.data.BeiZiAdCallBackChannelMethod
import com.beizi.beizi_sdk.data.BeiZiSdkMethodNames
import com.beizi.beizi_sdk.data.BeiZiSplashKeys
import com.beizi.beizi_sdk.data.SplashBottomModule
import com.beizi.beizi_sdk.view.SplashBottomViewFactory
import com.beizi.fusion.AdListener
import com.beizi.fusion.SplashAd
import com.example.amps_sdk.utils.dpToPx
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference


class BeiZiSplashManager private constructor() {
    private var mSplashAd: SplashAd? = null
    private var currentActivityRef: WeakReference<Activity>? =
        WeakReference(BeiZiEventManager.getInstance().getContext())
    // --- 新增成员变量用于存储底部View及其数据 ---
    private var customBottomLayout: View? = null
    private var customBottomLayoutId: Int = View.NO_ID
    private var splashBottomData: SplashBottomModule? = null
    companion object {
        @SuppressLint("StaticFieldLeak")
        @Volatile
        private var instance: BeiZiSplashManager? = null

        fun getInstance(): BeiZiSplashManager {
            return instance ?: synchronized(this) {
                instance ?: BeiZiSplashManager().also { instance = it }
            }
        }
    }

    private fun getCurrentActivity(): Activity? = currentActivityRef?.get()

    private val adCallback = object : AdListener {

        override fun onAdLoaded() {
            sendMessage(BeiZiAdCallBackChannelMethod.ON_AD_LOADED)
        }

        override fun onAdShown() {
            sendMessage(BeiZiAdCallBackChannelMethod.ON_AD_SHOWN)
        }

        override fun onAdFailedToLoad(errorCode: Int) {
            sendMessage(BeiZiAdCallBackChannelMethod.ON_AD_FAILED_TO_LOAD, errorCode)
        }

        override fun onAdClosed() {
            cleanupViewsAfterAdClosed()
            sendMessage(BeiZiAdCallBackChannelMethod.ON_AD_CLOSED)
        }

        override fun onAdTick(millisUnitFinished: Long) {
            sendMessage(BeiZiAdCallBackChannelMethod.ON_AD_TICK, millisUnitFinished)
        }

        override fun onAdClicked() {
            sendMessage(BeiZiAdCallBackChannelMethod.ON_AD_CLICKED)
        }
    }

    /**
     * 清理广告关闭后相关的视图和资源。
     * @param
     */
    private fun cleanupViewsAfterAdClosed() {
        val activity = getCurrentActivity()
        val decorView = activity?.window?.decorView as? ViewGroup
        decorView?.findViewWithTag<View>("splash_main_container_tag")?.let { viewToRemove ->
            decorView.removeView(viewToRemove)
        }
        SplashBottomModule.current = null
        // --- 清理成员变量中的底部View引用 ---
        customBottomLayout = null
        customBottomLayoutId = View.NO_ID
        splashBottomData = null
    }

    fun handleMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            BeiZiSdkMethodNames.SPLASH_CREATE -> createSplash(call, result)
            BeiZiSdkMethodNames.SPLASH_LOAD -> handleSplashLoad(call, result)
            BeiZiSdkMethodNames.SPLASH_SHOW_AD -> handleSplashShowAd(call, result) // 更改了参数传递
            BeiZiSdkMethodNames.SPLASH_GET_ECPM -> {
                result.success(mSplashAd?.ecpm ?: 0)
            }

            BeiZiSdkMethodNames.SPLASH_NOTIFY_RTB_WIN -> {
                mSplashAd?.sendWinNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.SPLASH_NOTIFY_RTB_LOSS -> {
                mSplashAd?.sendLossNotificationWithInfo(call.arguments as Map<*, *>)
                result.success(null)
            }

            BeiZiSdkMethodNames.SPLASH_GET_CUSTOM_EXT_DATA -> {
                result.success(mSplashAd?.customExtraData)
            }

            BeiZiSdkMethodNames.SPLASH_GET_CUSTOM_JSON_DATA -> {
                result.success(mSplashAd?.customExtraJsonData)
            }

            BeiZiSdkMethodNames.SPLASH_SET_BID_RESPONSE -> {
                mSplashAd?.setBidResponse(call.arguments as String)
                result.success(null)
            }

            BeiZiSdkMethodNames.SPLASH_SET_SPACE_PARAM -> {
                if (call.arguments != null && call.arguments is Map<*, *>) {
                    @Suppress("UNCHECKED_CAST")
                    val params = call.arguments as Map<String, Any>
                    mSplashAd?.setSpaceParam(params)
                }
                result.success(null)
            }

            BeiZiSdkMethodNames.SPLASH_CANCEL -> {
                cancel(result)
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }


    private fun createSplash(call: MethodCall, result: Result) {
        val activity = getCurrentActivity()
        if (activity == null) {
            result.error("LOAD_FAILED", "Activity not available for loading splash ad.", null)
            return
        }
        mSplashAd?.cancel(activity)
        val adOptionsMap = call.arguments<Map<String, Any>?>()
        val mSpaceId: String? = adOptionsMap?.get(BeiZiSplashKeys.AD_SPACE_ID) as String?
        val mTimeout: Int = adOptionsMap?.get(BeiZiSplashKeys.TOTAL_TIME) as Int? ?: 5000
        mSplashAd = SplashAd(activity, null, mSpaceId, adCallback, mTimeout.toLong())
        result.success(null)
    }

    private fun cancel(result: Result) {
        val activity = getCurrentActivity()
        if (activity == null) {
            result.error("LOAD_FAILED", "Activity not available for loading splash ad.", null)
            return
        }
        mSplashAd?.cancel(activity)
        // 取消时，也清除底部 View 引用
        customBottomLayout = null
        customBottomLayoutId = View.NO_ID
        splashBottomData = null
    }

    private fun handleSplashLoad(call: MethodCall, result: Result) {
        try {
            val activity = getCurrentActivity()
            if (activity == null) {
                result.error("LOAD_FAILED", "Activity not available for loading splash ad.", null)
                return
            }

            // --- 底部View创建和数据解析移动到这里 ---
            customBottomLayout = null
            customBottomLayoutId = View.NO_ID
            splashBottomData = null

            val adOptionsMap = call.arguments<Map<String, Any>?>()
            val mWidth: Int = adOptionsMap?.get(BeiZiSplashKeys.WIDTH) as Int? ?: 0
            val mHeight: Int = adOptionsMap?.get(BeiZiSplashKeys.HEIGHT) as Int? ?: 0
            val mWidget: Map<String, Any>? = adOptionsMap?.get(BeiZiSplashKeys.BOTTOM_WIDGET) as Map<String,Any>?

            // 解析底部 View 参数，注意：handleSplashLoad 的 call.arguments 结构需要包含底部 view 的数据
            splashBottomData = SplashBottomModule.fromMap(mWidget)

            // 简化第一个判断条件：如果 splashBottomData 为 null，则直接跳过整个 if 块
            if (splashBottomData != null && splashBottomData!!.height > 0) {
                // 在这里，splashBottomData 已经被智能转换为非空类型 SplashBottomModule

                customBottomLayout = SplashBottomViewFactory.createSplashBottomLayout(activity, splashBottomData)

                // 使用 let 块进一步优化对 customBottomLayout 的非空操作
                customBottomLayout?.let { layout ->
                    // 为 customBottomLayout 设置布局参数和 ID，以便在 showAd 中使用
                    val bottomLp = RelativeLayout.LayoutParams(
                        RelativeLayout.LayoutParams.MATCH_PARENT,
                        splashBottomData!!.height.dpToPx(activity) // splashBottomData 仍是非空
                    )
                    bottomLp.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM)
                    layout.layoutParams = bottomLp
                    customBottomLayoutId = View.generateViewId()
                    layout.id = customBottomLayoutId
                } ?: run {
                    // 如果 customBottomLayout 为 null，执行这个 else/run 块
                    println("BeiZiSplashManager: SplashBottomViewFactory returned null during load, no bottom view will be added.")
                }
            } else {
                println("BeiZiSplashManager: SplashBottomData not initialized or height is 0 during load, no bottom view will be added.")
            }
            // ------------------------------------------
            mSplashAd?.loadAd(mWidth, mHeight)
            result.success(true)
        } catch (e: Exception) {
            result.error("LOAD_EXCEPTION", "Error loading splash ad: ${e.message}", e.toString())
        }
    }

    private fun handleSplashShowAd(call: MethodCall, result: Result) {
        val activity = getCurrentActivity()
        if (mSplashAd == null) {
            result.error("SHOW_FAILED", "Splash ad not loaded.", null)
            return
        }
        if (activity == null) {
            result.error("SHOW_FAILED", "Activity not available for showing splash ad.", null)
            return
        }

        val decorView = activity.window.decorView as? ViewGroup
        if (decorView == null) {
            result.error("SHOW_FAILED", "Could not get decorView to show ad.", null)
            return
        }

        try {
            decorView.findViewWithTag<View>("splash_main_container_tag")?.let {
                decorView.removeView(it)
            }

            val mainContainerLocal = RelativeLayout(activity)
            mainContainerLocal.tag = "splash_main_container_tag"
            mainContainerLocal.layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )

            // --- 使用在 load 中创建的 customBottomLayout ---
            if (customBottomLayout != null && customBottomLayoutId != View.NO_ID) {
                // 确认 layoutParams 存在且设置了 ALIGN_PARENT_BOTTOM 规则
                // customBottomLayout!!.layoutParams 已经在 handleSplashLoad 中设置了

                // 将底部视图添加到主容器
                mainContainerLocal.addView(customBottomLayout)

                // 保持更新静态引用，虽然数据已经在 load 中解析，但 showAd 阶段可能需要
                SplashBottomModule.current = splashBottomData
            } else {
                println("BeiZiSplashManager: No custom bottom view available for showing ad.")
            }
            // ------------------------------------------

            val adContainerLocal = FrameLayout(activity)
            val adContainerParams = RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT
            )

            // --- 根据是否存在底部 View 来调整广告容器的位置 ---
            if (customBottomLayout != null && customBottomLayout!!.parent == mainContainerLocal && customBottomLayoutId != View.NO_ID) {
                adContainerParams.addRule(RelativeLayout.ABOVE, customBottomLayoutId)
            }
            // ------------------------------------------

            adContainerLocal.layoutParams = adContainerParams
            mainContainerLocal.addView(adContainerLocal) // 再添加广告容器

            decorView.addView(mainContainerLocal)
            mSplashAd?.show(adContainerLocal)
            result.success(true)
        } catch (e: Exception) {
            decorView.findViewWithTag<View>("splash_main_container_tag")?.let {
                decorView.removeView(it)
            }
            result.error("SHOW_EXCEPTION", "Error showing splash ad: ${e.message}", e.toString())
        }
    }

    private fun sendMessage(method: String, args: Any? = null) {
        BeiZiEventManager.getInstance().sendMessageToFlutter(method, args)
    }
}
