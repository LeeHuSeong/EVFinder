import 'dart:convert';

import 'package:evfinder/View/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/user_model.dart';
import 'package:http/http.dart' as http;
import '../Controller/login_controller.dart';

class SignupController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final loginController = LoginController();

  final UserModel _userModel = UserModel();
 
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  bool _isPasswordSecure(String password) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  bool _validateInput(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty) {
      _showMessage(context, '이메일을 입력하세요.');
      return false;
    }

    if (!isValidEmail(email)) {
      _showMessage(context, '올바른 이메일 형식을 입력하세요.');
      return false;
    }

    if (password.length < 6) {
      _showMessage(context, '비밀번호는 최소 6자 이상이어야 합니다.');
      return false;
    }

    if (password != confirmPassword) {
      _showMessage(context, '비밀번호가 일치하지 않습니다.');
      return false;
    }

    if (!_isPasswordSecure(password)) {
      _showMessage(context, '비밀번호는 8자 이상, 영문/숫자/특수문자를 포함해야 합니다.');
      return false;
    }

    return true;
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> signup(BuildContext context) async {
  final email = emailController.text.trim();
  final password = passwordController.text;

  try {
    final response = await http.post(
      Uri.parse('http://100.100.100.63:8081/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['success'] == true) {
        final String jwt = decoded['jwt'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()), // 직접 로그인 화면으로 이동
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${decoded['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서버 오류가 발생했습니다.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
    );
  }
}

}