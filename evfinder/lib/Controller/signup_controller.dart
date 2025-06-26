import 'package:evfinder/View/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Model/user_model.dart';

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
      final user = await _userModel.signUp(email, password);

      if (!context.mounted) return;

      if (user != null) {
        _showMessage(context, '회원가입 성공: ${user.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = '이미 등록된 이메일입니다.';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일 형식입니다.';
          break;
        case 'weak-password':
          errorMessage = '비밀번호가 너무 약합니다.';
          break;
        default:
          errorMessage = '회원가입 실패: ${e.message}';
      }

      _showMessage(context, errorMessage);
    } catch (e) {
      if (!context.mounted) return;
      _showMessage(context, '알 수 없는 오류가 발생했습니다.');
    }
  }
}