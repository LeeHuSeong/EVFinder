import 'dart:convert';

import 'package:evfinder/View/main_view.dart';
import 'package:flutter/material.dart';
import '../Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:evfinder/View/home_view.dart';
import 'package:http/http.dart' as http;


class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final UserModel _model = UserModel();


  void success(BuildContext context, String jwt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("로그인 성공")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainView()), // 또는 MainView
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  bool _isValidInput(String email, String password) {
    return email.isNotEmpty && password.length >= 6;
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!_isValidInput(email, password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이메일 또는 비밀번호를 확인하세요.")),
      );
      return;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Firebase ID 토큰을 가져오지 못했습니다')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://100.100.100.63:8081/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          final String jwt = decoded['jwt'];

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('로그인 성공')),
          );

          success(context, jwt); // 구글 로그인과 동일하게 처리
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패: ${decoded['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서버 오류가 발생했습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인 실패: ${e.toString()}')),
      );
    }
  }



  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 로그인 취소

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Firebase ID 토큰을 가져오지 못했습니다')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('http://100.100.100.63:8081/auth/login'), // 에뮬레이터용 주소
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          final String jwt = decoded['jwt'];

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google 로그인 성공')),
          );

          success(context, jwt);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패: ${decoded['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서버 오류 발생')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google 로그인 실패: ${e.toString()}')),
      );
    }
  }
}
