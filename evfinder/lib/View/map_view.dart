import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EVFinder 지도')),
      body: const Center(
        child: Text('지도 표시 예정 (여기에 Naver Map 표시 예정)'),
      ),
    );
  }
}
