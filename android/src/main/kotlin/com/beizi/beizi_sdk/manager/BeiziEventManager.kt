package com.beizi.beizi_sdk.manager

import android.app.Activity
import com.beizi.beizi_sdk.data.InitMethodNames
import com.beizi.beizi_sdk.data.SplashMethodNames
import com.beizi.beizi_sdk.data.InterstitialMethodNames
import com.beizi.beizi_sdk.data.NativeMethodNames
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference

class BeiziEventManager private constructor() : MethodCallHandler {

    private var channel: MethodChannel? = null
    private var mContext: WeakReference<Activity>? = null // 在 Android 中通常使用 Context

    companion object {
        private var sInstance: BeiziEventManager? = null
        fun getInstance(): BeiziEventManager {
            return sInstance ?: synchronized(this) {
                sInstance ?: BeiziEventManager().also { sInstance = it }
            }
        }
    }

    fun setContext(context: Activity) {
        this.mContext = WeakReference(context) // 存储 application context 避免内存泄漏
    }

    fun getContext(): Activity? {
        return this.mContext?.get()
    }

    /**
     * 初始化 MethodChannel 并设置回调处理器
     * @param binaryMessenger Flutter引擎的BinaryMessenger
     */
    fun init(binaryMessenger: BinaryMessenger) {
        if (channel == null) {
            channel = MethodChannel(binaryMessenger, "amps_sdk") // "amps_sdk" 是通道名称
            channel?.setMethodCallHandler(this) // 将当前类设置为回调处理器
        }
    }

    /**
     * 处理来自 Flutter 的方法调用
     */
    override fun onMethodCall(call: MethodCall, result: Result) {
        when {
            InitMethodNames.contains(call.method) -> {
                BeiziSDKInitManager.Companion.getInstance().handleMethodCall(call, result)
            }
            SplashMethodNames.contains(call.method) -> {
                //AMPSSplashManager.getInstance().handleMethodCall(call, result)
            }
            InterstitialMethodNames.contains(call.method) -> {
                //AMPSInterstitialManager.getInstance().handleMethodCall(call, result)
            }
            NativeMethodNames.contains(call.method) -> {
                //AMPSNativeManager.getInstance().handleMethodCall(call, result)
            }
            else -> {
                result.notImplemented() // 如果方法名未被识别
            }
        }
    }

    /**
     * 从原生端向 Flutter 发送消息
     * @param method 方法名
     * @param args 参数，可以是 null 或任何 Flutter 支持的类型
     */
    fun sendMessageToFlutter(method: String, args: Any?) { // args 类型改为 Any? 更灵活
        channel?.invokeMethod(method, args)
    }

    /**
     * 释放资源，清除 MethodChannel 的回调处理器和 Context
     */
    fun release() {
        channel?.setMethodCallHandler(null)
        channel = null // 可选，如果不再需要这个channel实例
        mContext = null
    }
}
