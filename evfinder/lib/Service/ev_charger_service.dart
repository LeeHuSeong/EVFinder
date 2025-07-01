import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/ev_charger_model.dart';
import '../constants/api_constants.dart';

class EvChargerService {
  static Future<List<EvCharger>> fetchChargers(String query) async {
    final url = Uri.parse('${ApiConstants.evApiBaseUrl}/findevc?query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List chargers = decoded['chargers'];
      return chargers.map((e) => EvCharger.fromJson(e)).toList();
    } else {
      throw Exception('충전소 데이터를 불러오지 못했습니다.');
    }
  }
}
