import 'package:evfinder/View/widget/profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Controller/login_controller.dart';
import '../View/change_password_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../View/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});


@override
  State<ProfileView> createState() => _ProfileViewState();
}
class _ProfileViewState extends State<ProfileView> {
  final LoginController _controller = LoginController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool isLoading = false;

  void handleChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordView()),
    );
  }

  void handleLogout(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Firebase 로그아웃
  await FirebaseAuth.instance.signOut();

  // await prefs.remove('uid');
  // await prefs.remove('userId');
  // await prefs.remove('jwt');
  await prefs.clear();

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginView()),
    (route) => false, 
  );

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("로그아웃 되었습니다.")),
  );
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ProfileCard(), //지금은 하드 코딩 되어있음.
          SizedBox(height: 20),
          Divider(thickness: 1.5, endIndent: 20, indent: 20),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: handleChangePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6), // blue-500
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      '비밀번호 변경',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                 onPressed: () => handleLogout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B7280), // gray-500
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),

               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
