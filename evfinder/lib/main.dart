import 'package:flutter/material.dart';
import 'View/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MVC 로그인',
      home: LoginView(),
    );
  }
}
