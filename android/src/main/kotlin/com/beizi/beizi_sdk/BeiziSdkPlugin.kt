package com.beizi.beizi_sdk

import com.beizi.beizi_sdk.manager.BeiZiEventManager
import com.beizi.beizi_sdk.manager.BeiZiPlatformViewManager
import com.beizi.beizi_sdk.utils.FlutterPluginUtil
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
        BeiZiEventManager.getInstance().release()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        FlutterPluginUtil.setActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {

    }
}
