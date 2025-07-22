import 'package:evfinder/View/widget/profile_card.dart';
import 'package:flutter/material.dart';
import '../Controller/login_controller.dart';
import '../View/change_password_view.dart';

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

               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
