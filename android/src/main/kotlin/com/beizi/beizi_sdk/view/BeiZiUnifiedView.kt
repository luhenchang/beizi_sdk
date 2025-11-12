package com.beizi.beizi_sdk.view

import android.content.Context
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.beizi.beizi_sdk.data.BeiZiNativeUnifiedKeys
import com.beizi.beizi_sdk.data.NativeUnifiedModule
import com.beizi.beizi_sdk.manager.AdResponseManager
import com.example.amps_sdk.utils.dpToPx
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

private const val TAG = "AMPSUnifiedView"
private const val UNIFIED_WIDGET_KEY = "unifiedWidget"

class BeiZiUnifiedView(
    private val context: Context,
    viewId: Int,
    binaryMessenger: BinaryMessenger,
    args: Any?
) : PlatformView, MethodChannel.MethodCallHandler {
    // 但由于构造函数中需要对 rootView 进行 addView，因此保留非延迟初始化
    private val unifiedView = FrameLayout(context).apply {
        layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.WRAP_CONTENT
        )
    }

    private val adId: String?
    private val unifiedModule: NativeUnifiedModule?
    private val rootView: ViewGroup

    init {
        // 1. 参数解析
        val creationArgs = parseCreationArgs(args)
        adId = creationArgs[BeiZiNativeUnifiedKeys.AD_ID] as? String
        @Suppress("UNCHECKED_CAST")
        val unifiedMap = creationArgs[UNIFIED_WIDGET_KEY] as? Map<String, Any>

        // 2. 提前进行必要的数据检查
        if (unifiedMap == null) {
            Log.e(TAG, "Initialization failed: 'unifiedWidget' map is missing or invalid.")
            unifiedModule = null
            rootView = createEmptyRootView() // 创建一个空的或占位的 rootView
        } else {
            unifiedModule = NativeUnifiedModule(unifiedMap)
            // 3. 根视图创建
            rootView = createRootView(unifiedMap)
            unifiedView.addView(rootView)
            // 4. 加载广告
            addAdViewToRoot()
        }
    }

    /**
     * 解析从 Flutter 传递过来的初始化参数。
     * 使用泛型推断避免冗余的类型转换。
     */
    @Suppress("UNCHECKED_CAST")
    private fun parseCreationArgs(args: Any?): Map<String, Any> {
        return args as? Map<String, Any> ?: emptyMap()
    }

    /**
     * 创建一个空的或占位的根视图，用于错误处理场景。
     */
    private fun createEmptyRootView(): ViewGroup {
        return FrameLayout(context).apply {
            layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                1 // 设置一个最小高度
            )
        }
    }

    /**
     * 创建根视图 AMPSUnifiedRootContainer 并设置其基本布局。
     * 优化点：使用 when 简化布局参数逻辑，明确变量命名。
     */
    private fun createRootView(args: Map<*, *>): ViewGroup {
        var viewRoot : ViewGroup? = null
        val nativeWidthDp = args[BeiZiNativeUnifiedKeys.WIDTH] as? Double
        val nativeHeightDp = args[BeiZiNativeUnifiedKeys.HEIGHT] as? Double
        val currentAdId = adId
        if (currentAdId!=null) {
            viewRoot = AdResponseManager.getInstance().getAdResponse(currentAdId)?.viewContainer
        }
        if ( viewRoot == null) {
            viewRoot = FrameLayout(context)
        }

        // 根据是否提供了宽度来计算像素值或使用 MATCH_PARENT
        val adViewWidthPx = nativeWidthDp?.dpToPx(context)
            ?: FrameLayout.LayoutParams.MATCH_PARENT
        val adViewHeightPx = nativeHeightDp?.dpToPx(context)
            ?: FrameLayout.LayoutParams.WRAP_CONTENT
        return viewRoot.apply {
            // 优化：合并布局参数的创建
            val containerLayout = FrameLayout.LayoutParams(
                adViewWidthPx,
                adViewHeightPx
            ).apply {
                gravity = Gravity.CENTER_HORIZONTAL
            }
            layoutParams = containerLayout
            // 将广告视图的内部布局参数直接保存到 tag 中
            val adViewParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            ).apply {
                gravity = Gravity.CENTER
            }
            tag = adViewParams // tag 的类型改为 FrameLayout.LayoutParams，避免后续强制转换失败
        }
    }

    /**
     * 获取广告视图并添加到根视图中。
     * 优化点：使用 Elvis 运算符和 'let' 链式调用简化空值检查。
     */
    private fun addAdViewToRoot() {
        val currentAdId = adId ?: return
        val module = unifiedModule ?: return
        val adItem = AdResponseManager.getInstance().getAdResponse(currentAdId) ?: return

        // 确保 tag 是正确的 FrameLayout.LayoutParams 类型
        val params = rootView.tag as? FrameLayout.LayoutParams ?: run {
            Log.e(TAG, "Layout params not found in rootView tag for adId: $currentAdId")
            return
        }

        runCatching {
            // 使用 let 避免嵌套，同时确保 nativeView 渲染成功
            AmpsUnifiedFrameLayout(context).let { it ->
                it.render(module, adItem, params, currentAdId)?.let { renderResult ->
                    rootView.addView(it)
                    adItem.registerViewForInteraction(
                        renderResult.clickableViews,
                    )
                }
            }
        }.onFailure {
            Log.e(TAG, "Failed to add ad view for adId: $currentAdId", it)
        }
    }

    override fun getView(): View = unifiedView // 简化 getter

    override fun dispose() {
        adId?.let { id ->
            AdResponseManager.getInstance().removeAdResponse(id) // 清理 Manager 资源
        }
        rootView.removeAllViews()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        // 通常在 PlatformView 中，这个方法用于接收来自 Flutter 的方法调用
        Log.d(TAG, "Received method call: ${call.method}")
        result.notImplemented()
    }
}