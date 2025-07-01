import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/ev_charger_model.dart';
import '../constants/api_constants.dart';

class FavoriteService {
  /// 즐겨찾기 추가
  static Future<bool> addFavorite(String userId, EvCharger charger) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/add');

    final body = {
      "userId": userId,
      "station": {
        "statId": charger.statId,
        "name": charger.name,
        "addr": charger.addr,
        "lat": charger.lat,
        "lng": charger.lng,
        "useTime": charger.useTime,
        "output": charger.output,
        "method": charger.method,
        "chgerType": charger.chgerType,
        "busiNm": charger.busiNm,
        "stat": charger.stat,
        "distance": charger.distance,
        "timestamp": DateTime.now().toIso8601String(),
      }
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  /// 즐겨찾기 목록 조회
  static Future<List<Map<String, dynamic>>> fetchFavorites(String userId) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/list?userId=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch favorites');
    }
  }


  static Future<bool> removeFavorite(String userId, String statId) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/remove?userId=$userId&statId=$statId');
    final response = await http.delete(url);
    return response.statusCode == 200;
  }


  static Future<List<Map<String, dynamic>>> fetchFavoritesWithStat({
    required String userId,
    required double lat,
    required double lng,
  }) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/listWithStat?userId=$userId&lat=$lat&lng=$lng');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch updated favorite chargers');
    }
  }



  static Future<List<String>> getFavoriteStatIds(String userId) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/list?userId=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => e['statId'] as String).toList();
    } else {
      throw Exception('Failed to fetch favorite statIds');
    }
  }
}
