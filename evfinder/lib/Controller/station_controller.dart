import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/station_model.dart';

class StationController {
  final _firestore = FirebaseFirestore.instance;

  Future<List<ChargingStation>> fetchStations() async {
    final snapshot = await _firestore.collection('charging_stations').get();

    return snapshot.docs.map((doc) {
      return ChargingStation.fromMap(doc.id, doc.data());
    }).toList();
  }
}
