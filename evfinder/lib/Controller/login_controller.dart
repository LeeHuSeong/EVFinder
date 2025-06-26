import 'package:evfinder/View/main_view.dart';
import 'package:flutter/material.dart';
import '../Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final UserModel _model = UserModel();

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("이메일 또는 비밀번호를 확인하세요.")));
      return;
    }

    try {
      final user = await _model.signIn(email, password);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("로그인 성공: ${user.email}")));
        //로그인 성공 후 화면 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainView()), // HomeView는 실제 구현한 화면으로 바꾸세요
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = '사용자를 찾을 수 없습니다.';
          break;
        case 'wrong-password':
          message = '비밀번호가 틀렸습니다.';
          break;
        case 'email-already-in-use':
          message = '이미 등록된 이메일입니다.';
          break;
        case 'invalid-email':
          message = '유효하지 않은 이메일 형식입니다.';
          break;
        case 'weak-password':
          message = '비밀번호가 너무 약합니다.';
          break;
        default:
          message = '오류가 발생했습니다: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('알 수 없는 오류가 발생했습니다.')));

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
        // 로그인 성공 후 화면 이동 가능
        // Navigator.pushReplacement(...);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google 로그인 실패: ${e.toString()}')));
    }
  }
}
