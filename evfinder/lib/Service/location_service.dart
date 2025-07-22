import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class LocationService {

  static Future<String> changeGPStoAddressName(double lat, double lng) async {
    final url = Uri.parse('${ApiConstants.addressApiBaseUrl}lat=$lat&lng=$lng');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['address_name'];
    } else {
      throw Exception('Failed to change address');
    }
  }
}
