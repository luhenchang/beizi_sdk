import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'beizi_sdk_method_channel.dart';

abstract class BeiziSdkPlatform extends PlatformInterface {
  /// Constructs a BeiziSdkPlatform.
  BeiziSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static BeiziSdkPlatform _instance = MethodChannelBeiziSdk();

  /// The default instance of [BeiziSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelBeiziSdk].
  static BeiziSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BeiziSdkPlatform] when
  /// they register themselves.
  static set instance(BeiziSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
