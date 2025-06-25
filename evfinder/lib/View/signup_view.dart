import 'package:flutter/material.dart';
import '../Controller/signup_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final SignupController _controller = SignupController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller.emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller.passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller.confirmPasswordController,
              decoration: const InputDecoration(labelText: '비밀번호 확인'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _controller.signUp(context),
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
