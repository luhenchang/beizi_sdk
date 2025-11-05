package com.beizi.beizi_sdk

import com.beizi.beizi_sdk.manager.BeiziEventManager
import com.beizi.beizi_sdk.manager.BeiziPlatformViewManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** AmpsSdkPlugin */
class BeiziSdkPlugin :
  FlutterPlugin, ActivityAware {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    BeiziEventManager.getInstance().init(flutterPluginBinding.binaryMessenger)
    BeiziPlatformViewManager.getInstance().init(flutterPluginBinding)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    BeiziEventManager.getInstance().setContext(binding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
    BeiziEventManager.getInstance().release()
  }
}
