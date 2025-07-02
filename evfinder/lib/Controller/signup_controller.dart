import 'package:evfinder/View/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/user_model.dart';
import '../Service/SingupService.dart';
class SignupController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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

  Future<void> signUp(BuildContext context) async {
  if (!_validateInput(context)) return;

  final email = emailController.text.trim();
  final password = passwordController.text;

  try {
    final result = await SignupService.signup(email, password);

    if (!context.mounted) return;

    if (result['success'] == true) {
      _showMessage(context, '회원가입 성공: ${result['email']}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    } else {
      _showMessage(context, result['message']); // 실패 시 서버가 준 메시지 출력
    }
  } catch (e) {
    if (!context.mounted) return;

    _showMessage(context, '서버 오류가 발생했습니다.');
  }
}

}