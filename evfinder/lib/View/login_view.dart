import 'package:flutter/material.dart';
import '../Controller/login_controller.dart';
import 'signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  bool isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleLogin() async {
    setState(() {
      isLoading = true;
    });
    await _controller.login(context);
    await Future.delayed(const Duration(seconds: 1)); 
    setState(() {
      isLoading = false;
    });
  }

  void handleGoogleLogin() {
    _controller.signInWithGoogle(context);
  }

  void handleSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // 부드러운 배경색
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 로고
              Center(
                child: Container(
                  width: 120, // 배경 원 크기 (아이콘보다 큼)
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5), // emerald-100
                    shape: BoxShape.circle, // 완전한 원
                  ),
                  child: Center(
                    child: Icon(
                      Icons.electric_car,
                      size: 48, // 아이콘 크기 (작게 유지)
                      color: const Color(0xFF10B981), // emerald-500
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 타이틀
              const Text(
                'EVFinder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981), // emerald-500
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '전기차 충전소를 쉽게 찾아보세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),

              // 이메일 입력
              TextField(
                controller: _controller.emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  prefixIcon: const Icon(Icons.mail_outline, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // 비밀번호 입력
              TextField(
                controller: _controller.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // 로그인 버튼
              ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981), // emerald-500
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  isLoading ? '로그인 중...' : '로그인',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),

              // 구글 로그인 버튼
              OutlinedButton(
                onPressed: handleGoogleLogin,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFA7F3D0)), // emerald-200
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.language, color: Color(0xFF10B981)), // Chrome 아이콘 대체
                    SizedBox(width: 8),
                    Text(
                      '구글로 로그인',
                      style: TextStyle(fontSize: 16, color: Color(0xFF10B981)), // emerald-500
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // 회원가입 버튼
              Center(
                child: TextButton(
                  onPressed: handleSignup,
                  child: const Text(
                    '아직 계정이 없으신가요? 회원가입',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 추가 정보
              const Center(
                child: Text(
                  '전국 전기차 충전소 정보를 한눈에',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}