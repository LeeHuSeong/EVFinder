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
      final Map<String, dynamic> json = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(json['favorites']);
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
  }) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/global/listWithStat?userId=$userId');

    final response = await http.get(url);
    print('[DEBUG] 응답: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic> && body.containsKey('favorites')) {
        final list = List<Map<String, dynamic>>.from(body['favorites']);

        return list.map((e) {
          final rawDistance = e['distance'];
          final parsedDistance = (rawDistance is num)
              ? rawDistance
              : double.tryParse(rawDistance.toString()) ?? 0.0;

          final rawStat = e['stat'];
          final parsedStat = (rawStat is int)
              ? rawStat
              : int.tryParse(rawStat.toString()) ?? -1;

          return {
            ...e,
            'distance': parsedDistance.toStringAsFixed(1),
            'stat': parsedStat,
          };
        }).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to fetch updated favorite chargers');
    }
  }


  //없애도 될 것 같기도.
  static Future<int> fetchStat(String statId) async {
    final url = Uri.parse('${ApiConstants.evApiBaseUrl}/stat?statId=$statId');
    final response = await http.get(url);

    print('[DEBUG] 요청 URL: $url');
    print('[DEBUG] 응답: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return int.tryParse(json['stat'].toString()) ?? -1;
    } else {
      throw Exception('Failed to fetch stat for $statId');
    }
  }


  static Future<List<String>> getFavoriteStatIds(String userId) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/list?userId=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> favorites = json['favorites'];
        return favorites.map((e) => e['statId'].toString()).toList();
      } else {
        print("서버 응답 에러: ${response.statusCode}");
        return []; // 실패 시에도 빈 리스트 반환
      }
    } catch (e) {
      print("statId 받아오기 실패: $e");
      return []; // 네트워크 오류 등 실패 시도 처리
    }
  }

  // 없애도 될 것 같기도 2
  static Future<bool> updateStat(String userId, String statId, int stat) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/updateStat');

    final body = {
      "userId": userId,
      "statId": statId,
      "stat": stat,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }
}