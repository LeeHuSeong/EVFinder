import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/ev_charger_model.dart';
import '../Model/search_charger_model.dart';
import '../constants/api_constants.dart';

class SearchChargerController {
  static Future<List<SearchChargers>> searchUseKeyword(String query) async {
    final url = Uri.parse('${ApiConstants.keywordForSearch}/placelist?query=$query');
    final response = await http.get(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      final List searchChargers = decoded;
      return searchChargers.map((e) => SearchChargers.fromJson(e)).toList();
    } else {
      throw Exception('검색 결과를 불러오지 못했습니다.');
    }
  }
}
