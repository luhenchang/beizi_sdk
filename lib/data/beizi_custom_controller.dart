import 'beizi_location.dart';

/// Flutter layer interface for configuring custom data and permissions,
/// corresponding to the native Android `BeiZiCustomController`.
///
/// This class holds all the settings that will be passed to the Android side
/// to implement the behavior of `BeiZiCustomController`.
class BeiziCustomController {
  /// 是否支持个性化设置
  final bool? isPersonalRecommend;
  /// Whether location information can be used. Defaults to `true`.
  /// Corresponds to `isCanUseLocation()`.
  final bool canUseLocation;

  /// Custom location information. Can be null if not provided or disabled.
  /// Corresponds to `getLocation()`.
  final BeiziLocation? location;

  /// Whether Wi-Fi state can be used. Defaults to `true`.
  /// Corresponds to `isCanUseWifiState()`.
  final bool canUseWifiState;

  /// Whether phone state (e.g., IMEI) can be used. Defaults to `true`.
  /// Corresponds to `isCanUsePhoneState()`.
  final bool canUsePhoneState;

  /// Whether OAID (Open Anonymous Device Identifier) can be used. Defaults to `true`.
  /// Corresponds to `isCanUseOaid()`.
  final bool canUseOaid;

  /// Whether GAID (Google Advertising ID) can be used. Defaults to `true`.
  /// Corresponds to `isCanUseGaid()`.
  final bool canUseGaid;

  /// Custom provided OAID value. Can be null.
  /// Corresponds to `getDevOaid()`.
  final String? devOaid;

  /// Custom provided OAID version. Can be null.
  /// Corresponds to `getOaidVersion()`.
  final String? oaidVersion;

  /// Whether the installed app list can be accessed. Defaults to `true`.
  /// Corresponds to `isCanUseAppList()`.
  final bool canUseAppList;

  /// Whether to forbid access to device sensors (e.g., accelerometer). Defaults to `false`.
  /// Corresponds to `forbidSensor()`.
  final bool shouldForbidSensor;

  /// Whether the Android ID can be used. Defaults to `true`.
  /// Corresponds to `isCanUseAndroidId()`.
  final bool canUseAndroidId;

  /// Custom provided Android ID value. Can be null.
  /// Corresponds to `getAndroidId()`.
  final String? androidId;

  BeiziCustomController({
    this.isPersonalRecommend,
    this.canUseLocation = true,
    this.location,
    this.canUseWifiState = true,
    this.canUsePhoneState = true,
    this.canUseOaid = true,
    this.canUseGaid = true,
    this.devOaid,
    this.oaidVersion,
    this.canUseAppList = true,
    this.shouldForbidSensor = false,
    this.canUseAndroidId = true,
    this.androidId,
  });

  /// Converts the BeiziCustomController object into a Map for transmission
  /// over a MethodChannel to the native Android side.
  Map<String, dynamic> toMap() {
    return {
      'isPersonalRecommend': isPersonalRecommend,
      'canUseLocation': canUseLocation,
      'location': location?.toMap(), // Nested map for location
      'canUseWifiState': canUseWifiState,
      'canUsePhoneState': canUsePhoneState,
      'canUseOaid': canUseOaid,
      'canUseGaid': canUseGaid,
      'devOaid': devOaid,
      'oaidVersion': oaidVersion,
      'canUseAppList': canUseAppList,
      'shouldForbidSensor': shouldForbidSensor,
      'canUseAndroidId': canUseAndroidId,
      'androidId': androidId,
    };
  }
}
