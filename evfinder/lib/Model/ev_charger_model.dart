class EvCharger {
final String statId;
final String name;
final String addr;
final double lat;
final double lng;
final String useTime;
final String output;
final String method;
final String chgerType;
final String busiNm;
final int stat;
final double distance;

EvCharger({
  required this.statId,
  required this.name,
  required this.addr,
  required this.lat,
  required this.lng,
  required this.useTime,
  required this.output,
  required this.method,
  required this.chgerType,
  required this.busiNm,
  required this.stat,
  required this.distance,
});

factory EvCharger.fromJson(Map<String, dynamic> json) {
  return EvCharger(
    statId: json['statId'] ?? '',
    name: json['name'] ?? '',
    addr: json['addr'] ?? '',
    lat: double.tryParse(json['lat'].toString()) ?? 0.0,
    lng: double.tryParse(json['lng'].toString()) ?? 0.0,
    useTime: json['useTime'] ?? '',
    output: json['output'] ?? '',
    method: json['method'] ?? '',
    chgerType: json['chgerType'] ?? '',
    busiNm: json['busiNm'] ?? '',
    stat: int.tryParse(json['stat'].toString()) ?? 0,
    distance: (json['distance'] as num).toDouble(),
    );
  }
}
