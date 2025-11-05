///坐标系类型
enum CoordinateType {
  wgs84('WGS84'),
  gcj02('GCJ02'),
  baidu('BAIDU');

  final String value;

  const CoordinateType(this.value);

  @override
  String toString() => value;
}