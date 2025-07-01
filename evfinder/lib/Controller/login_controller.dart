import 'package:evfinder/View/main_view.dart';
import 'package:flutter/material.dart';
import '../Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Service/LoginService.dart';
import 'package:evfinder/View/home_view.dart';
import '../Model/Customuser.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final UserModel _model = UserModel();


  void success(BuildContext context, User user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("로그인 성공: ${user.email}")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainView()), // 또는 MainView
    );
  }
  void successCustom(BuildContext context, CustomUser user) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("로그인 성공: ${user.email}")),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MainView()),
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
    CustomUser? user = await LoginService.login(email, password);

    if (user != null) {
      successCustom(context, user); // 성공 시 CustomUser 객체 넘기기
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("이메일 또는 비밀번호가 올바르지 않습니다.")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('서버 오류가 발생했습니다.')),
    );
  }
}


  
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 로그인 취소

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google 로그인 성공: ${user.email}')));
        success(context, user);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google 로그인 실패: ${e.toString()}')));
    }
  }
}
