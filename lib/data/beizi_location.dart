import 'beizi_init_data.dart';

/// Represents geographic location information, equivalent to the Android BeiZiLocation class.
class BeiziLocation {
  /// Longitude, corresponds to `getLongitude()`.
  final String longitude;

  /// Latitude, corresponds to `getLatitude()`.
  final String latitude;

  /// The type of location`.
  final CoordinateType type;

  /// The timestamp of the location fix in milliseconds since the epoch. Corresponds to `getTime()`.
  final int? time;

  BeiziLocation(this.longitude, this.latitude, this.type, this.time);

  /// Converts the BeiziLocation object into a Map for transmission over a MethodChannel.
  Map<String, dynamic> toMap() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'type': type.value,
      'time': time,
    };
  }
}
