import 'package:cloud_firestore/cloud_firestore.dart';

class ChargingStation {
  final String id;
  final String name;
  final GeoPoint location;
  final String statId;
  final String busiId;

  ChargingStation({
    required this.id,
    required this.name,
    required this.location,
    required this.statId,
    required this.busiId,
  });

  factory ChargingStation.fromMap(String id, Map<String, dynamic> data) {
    return ChargingStation(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      statId: data['statId'] ?? '',
      busiId: data['busiId'] ?? '',
    );
  }
}