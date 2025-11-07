package com.beizi.beizi_sdk.view

import android.content.Context
import android.util.Log
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import com.beizi.beizi_sdk.data.BeiZiNativeKeys
import com.beizi.beizi_sdk.manager.AdViewManager
import com.example.amps_sdk.utils.dpToPx
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


class BeiZiNativeView(
    private val context: Context,
    viewId: Int,
    binaryMessenger: BinaryMessenger,
    args: Any?
) : PlatformView, MethodChannel.MethodCallHandler {
    // FrameLayout 是最终暴露给 Flutter 的根视图
    private var rootView: FrameLayout
    private val adId: String?
    init {
        val creationArgs = parseCreationArgs(args)
        adId = creationArgs[BeiZiNativeKeys.AD_ID] as? String
        rootView = createRootView(creationArgs)
        addAdViewToRoot()
    }

    /**
     * 解析从 Flutter 传递过来的初始化参数
     */
    private fun parseCreationArgs(args: Any?): Map<*, *> {
        return args as? Map<*, *> ?: emptyMap<Any, Any>()
    }

    /**
     * 创建根视图 FrameLayout 并设置其基本布局
     */
    private fun createRootView(args: Map<*, *>): FrameLayout {
        val nativeWidth = args[BeiZiNativeKeys.WIDTH] as? Double

        return FrameLayout(context).apply {
            // FrameLayout 本身填充父容器
            layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            )

            // 如果 Flutter 端传入了 width，计算子 View 的宽度,这里避免将广告宽度拉长。
            val adViewWidth = nativeWidth?.toInt()?.dpToPx(context)
                ?: FrameLayout.LayoutParams.MATCH_PARENT // 默认填充宽度

            // 子 View (广告) 的布局参数
            val adViewParams = FrameLayout.LayoutParams(
                adViewWidth,
                FrameLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                gravity = Gravity.CENTER
            }
            // 将计算好的布局参数暂存到 tag 中，待添加子 View 时使用
            tag = adViewParams
        }
    }

    /**
     * 获取广告视图并添加到根视图中
     */
    private fun addAdViewToRoot() {
        val adId = this.adId ?: return
        runCatching {
            val nativeView = AdViewManager.getInstance().getAdView(adId)
            val params = rootView.tag as? FrameLayout.LayoutParams
            // 确保 nativeView 和 params 都存在
            if (nativeView != null && params != null) {
                // 如果 nativeView 已经有父 View，先将其移除，避免崩溃
                (nativeView.parent as? FrameLayout)?.removeView(nativeView)
                nativeView.layoutParams = params
                rootView.addView(nativeView)
            }
        }.onFailure {
            Log.e("BeiZiNativeView", "Failed to add ad view for adId: $adId", it)
        }
    }

    override fun getView(): View {
        return rootView
    }

    override fun dispose() {
        adId?.let {
            AdViewManager.getInstance().removeAdView(it) // 假设 Manager 有这样的清理方法
        }
        rootView.removeAllViews()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }
}