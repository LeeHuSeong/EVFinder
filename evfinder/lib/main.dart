import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'View/login_view.dart'; // 로그인 화면 import
import 'View/station_list_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterNaverMap().init(
      clientId: 'qe05hz13nm',
      onAuthFailed: (ex) => switch (ex) {
        NQuotaExceededException(:final message) =>
            print("사용량 초과 (message: $message)"),
        NUnauthorizedClientException() ||
        NClientUnspecifiedException() ||
        NAnotherAuthFailedException() =>
            print("인증 실패: $ex"),
      });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EVFinder',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true),
      //: const LoginView(), // 로그인 화면이 처음 뜨도록
      home: const StationListView() //데이터베이스 연결 확인용
    );
  }
}
