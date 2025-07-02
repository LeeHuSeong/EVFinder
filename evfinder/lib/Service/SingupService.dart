import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupService {
  static const String baseUrl = 'http://100.100.100.58:8081/api';

  static Future<Map<String, dynamic>> signup(String email, String password) async {
    final url = Uri.parse('$baseUrl/signup');
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
        print('회원가입 성공: ${decoded['email']}');
        return {'success': true, 'uid': decoded['uid'], 'email': decoded['email']};
      } else {
        print('회원가입 실패: ${decoded['message']}');
        return {'success': false, 'message': decoded['message']};
      }
    } else {
      throw Exception('서버 연결 실패');
    }
  }
}
