package com.beizi.beizi_sdk

import com.beizi.beizi_sdk.manager.BeiZiEventManager
import com.beizi.beizi_sdk.manager.BeiZiPlatformViewManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** AmpsSdkPlugin */
class BeiziSdkPlugin :
    FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        BeiZiEventManager.getInstance().init(flutterPluginBinding.binaryMessenger)
        BeiZiPlatformViewManager.getInstance().init(flutterPluginBinding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        BeiZiEventManager.getInstance().setContext(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        BeiZiEventManager.getInstance().release()
    }
}
