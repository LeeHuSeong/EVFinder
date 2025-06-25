import '../Model/user_model.dart';
import 'package:flutter/material.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  UserModel getUser() {
    return UserModel(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  void login(BuildContext context) {
    final user = getUser();

    if (!user.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이메일 또는 비밀번호를 확인하세요.")),
      );
      return;
    }

    // TODO: Firebase Auth 등 로그인 로직 추가
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("로그인 성공: ${user.email}")),
    );
  }
}
