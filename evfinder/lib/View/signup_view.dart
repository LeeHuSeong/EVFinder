import 'package:flutter/material.dart';
import '../Controller/signup_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final SignupController _controller = SignupController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    _controller.signup(context);
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // React 스타일 대기

    setState(() {
      _isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // 뒤로가기 버튼
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 로고 섹션
                Column(
                  children: [
                    // 타이틀
                    const Text(
                      'EVFinder',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981), // emerald-500
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 서브타이틀
                    const Text(
                      '새로운 계정을 만들어보세요',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280), // gray-600
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 40),

                // 회원가입 카드
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 이메일 입력
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '이메일',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151), // gray-700
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: '이메일을 입력하세요',
                              prefixIcon: const Icon(
                                Icons.mail_outline,
                                color: Color(0xFF9CA3AF), // gray-400
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB), // gray-200
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF10B981), // emerald-500
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 비밀번호 입력
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '비밀번호',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151), // gray-700
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _controller.passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '비밀번호를 입력하세요',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF9CA3AF), // gray-400
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB), // gray-200
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF10B981), // emerald-500
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '비밀번호 확인',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151), // gray-700
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _controller.confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '비밀번호를 입력하세요',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF9CA3AF), // gray-400
                                size: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB), // gray-200
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF10B981), // emerald-500
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                
                      // 회원가입 버튼
                      ElevatedButton(
                         onPressed: _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981), // emerald-500
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: const Color(0xFF9CA3AF),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                '회원가입',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 추가 정보
                const Text(
                  '가입하시면 이용약관과 개인정보처리방침에 동의하게 됩니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280), // gray-500
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}
