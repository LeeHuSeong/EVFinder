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
      _showMessage(context, '이메일 또는 비밀번호를 확인하세요.');
      return;
    }

    try {
      final user = await _model.signIn(email, password);
      if (user != null) {
        _showMessage(context, "로그인 성공: ${user.email}");
        // 로그인 성공 후 화면 이동 처리
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = '등록되지 않은 이메일입니다.';
          break;
        case 'wrong-password':
          message = '비밀번호가 틀렸습니다.';
          break;
        case 'invalid-email':
          message = '이메일 형식이 올바르지 않습니다.';
          break;
        case 'user-disabled':
          message = '이 계정은 비활성화되었습니다.';
          break;
        case 'too-many-requests':
          message = '잠시 후 다시 시도해주세요. (요청 과다)';
          break;
        case 'operation-not-allowed':
          message = '이메일/비밀번호 로그인 방식이 비활성화되어 있습니다.';
          break;
        case 'invalid-credential':
        case 'expired-action-code':
        case 'invalid-verification-code':
          message = '인증 정보가 올바르지 않거나 만료되었습니다.';
          break;
        default:
          message = '로그인 실패: ${e.message}';
      }
      _showMessage(context, message);
    } catch (e) {
      _showMessage(context, '알 수 없는 오류가 발생했습니다.');
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 로그인 취소

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        _showMessage(context, 'Google 로그인 성공: ${user.email}');
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
      }
    } catch (e) {
      _showMessage(context, 'Google 로그인 실패: ${e.toString()}');
    }
  }

  void _showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
