package com.beizi.beizi_sdk.manager
import com.beizi.beizi_sdk.data.BeiZiPlatformViewRegistry
import com.beizi.beizi_sdk.view.NativeFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.StandardMessageCodec

class BeiZiPlatformViewManager private constructor() {
    companion object {
        @Volatile
        private var sInstance: BeiZiPlatformViewManager? = null

        fun getInstance(): BeiZiPlatformViewManager {
            return sInstance ?: synchronized(this) {
                sInstance ?: BeiZiPlatformViewManager().also { sInstance = it }
            }
        }
    }

    /**
     * 初始化并注册平台视图工厂。
     * 通常在 Flutter 插件的 onAttachedToEngine 方法中调用。
     *
     * @param binding FlutterPluginBinding，用于访问 BinaryMessenger 和 PlatformViewRegistry。
     */
    fun init(binding: FlutterPluginBinding) {
        val platformViewRegistry = binding.platformViewRegistry
        val binaryMessenger = binding.binaryMessenger
        platformViewRegistry.registerViewFactory(
            BeiZiPlatformViewRegistry.BeiZi_SDK_NATIVE_VIEW_ID,
            NativeFactory(binaryMessenger, StandardMessageCodec.INSTANCE)
        )
//
//        // 注册 Unified 视图工厂
//        platformViewRegistry.registerViewFactory(
//            AMPSPlatformViewRegistry.AMPS_SDK_UNIFIED_VIEW_ID,
//            UnifiedFactory(binaryMessenger, StandardMessageCodec.INSTANCE)
//        )
    }
}

