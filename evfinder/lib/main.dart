import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'View/login_view.dart';  // 로그인 화면 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVFinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginView(),  // 로그인 화면이 처음 뜨도록
    );
  }
}