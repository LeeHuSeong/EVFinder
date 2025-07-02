import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/Customuser.dart';

class LoginService {
  static const String baseUrl = 'http://114.70.216.85:8081/api';

  static Future<CustomUser?> login(String email, String password) async {
  final url = Uri.parse('$baseUrl/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);

    if (decoded['success'] == true) {
      print(decoded['message']); // 로그인 성공
      return CustomUser(email: email); // 여기 수정
    } else {
      print(decoded['message']); // 로그인 실패
      return null;
    }
  } else {
    throw Exception('서버 연결 실패');
  }
}

}
