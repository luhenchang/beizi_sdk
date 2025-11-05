class BeiziSdkMethodNames {
  /// 初始化AMPS广告SDK的方法名
  static const String init = 'BeiziSdk_init';
}
///坐标系类型
enum CoordinateType {
  //GCJ-02   WGS-84   BAIDU
  wgs84('WGS-84'),
  gcj02('GCJ-02'),
  baidu('BAIDU');

  final String value;

  const CoordinateType(this.value);

  @override
  String toString() => value;
}