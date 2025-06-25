import 'package:evfinder/View/login_view.dart';
import 'package:flutter/material.dart';
import '../Model/user_model.dart';

class SignupController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final UserModel _userModel = UserModel();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  bool _validateInput(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 또는 비밀번호를 올바르게 입력하세요.')),
      );
      return false;
    }
    return true;
  }

  Future<void> signUp(BuildContext context) async {
    if (!_validateInput(context)) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      final user = await _userModel.signUp(email, password);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공: ${user.email}')),
        );
        //회원가입 성공 후 로그인 화면 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
      );
    }
  }
}
