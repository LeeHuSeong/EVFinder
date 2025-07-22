import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/ev_charger_model.dart';
import '../constants/api_constants.dart';

class FavoriteService {
  /// 즐겨찾기 추가
  static Future<bool> addFavorite(String uid, EvCharger charger) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/add');

    final body = {
      "uid": uid,
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
    print('[DEBUG] 즐겨찾기 추가 요청: $body');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print('[DEBUG] 응답 코드: ${response.statusCode}');
    print('[DEBUG] 응답 내용: ${response.body}');
    return response.statusCode == 200;
  }

  /// 즐겨찾기 목록 조회
  static Future<List<Map<String, dynamic>>> fetchFavorites(String uid) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/list?uid=$uid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(json['favorites']);
    } else {
      throw Exception('Failed to fetch favorites');
    }
  }


  static Future<bool> removeFavorite(String uid, String statId) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/remove?uid=$uid&statId=$statId');
    final response = await http.delete(url);
    return response.statusCode == 200;
  }


  static Future<List<Map<String, dynamic>>> fetchFavoritesWithStat({
    required String uid,
  }) async {

    // 임시값 (서울)
    final double userLat = 37.5665;
    final double userLng = 126.9780;

    final url = Uri.parse(
      '${ApiConstants.favoriteApiBaseUrl}/global/listWithStat'
          '?uid=$uid&lat=$userLat&lng=$userLng',
    );

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


  static Future<List<String>> getFavoriteStatIds(String uid) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/list?uid=$uid');

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


  static Future<bool> updateStat(String uid, String statId, int stat) async {
    final url = Uri.parse('${ApiConstants.favoriteApiBaseUrl}/updateStat');

    final body = {
      "uid": uid,
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