import 'dart:math';

import 'package:evfinder/View/main_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'Controller/location_permission_controller.dart';
import 'View/login_view.dart'; // 로그인 화면 import
import 'View/station_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final jwt = prefs.getString('jwt');
  await Firebase.initializeApp(); // Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterNaverMap().init(
    clientId: 'qe05hz13nm',
    onAuthFailed: (ex) => switch (ex) {
      NQuotaExceededException(:final message) => print(
        "사용량 초과 (message: $message)",
      ),
      NUnauthorizedClientException() ||
      NClientUnspecifiedException() ||
      NAnotherAuthFailedException() => print("인증 실패: $ex"),
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final jwt = prefs.getString('jwt');
    return jwt != null; // JWT가 있으면 자동 로그인
  }

  @override
  Widget build(BuildContext context) {
    var locationPermissionController = LocationPermissionController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      locationPermissionController.permissionCheck();
    }); //위치 권한 확인
    return MaterialApp(
      title: 'EVFinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),//home: const StationListView() //데이터베이스 연결 확인용
     home: FutureBuilder<bool>(
        future: checkAutoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}