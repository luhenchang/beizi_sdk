import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'beizi_sdk_platform_interface.dart';

/// An implementation of [BeiziSdkPlatform] that uses method channels.
class MethodChannelBeiziSdk extends BeiziSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('beizi_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
