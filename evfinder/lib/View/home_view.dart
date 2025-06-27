import 'package:evfinder/View/widget/search_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../Service/marker_service.dart'; // ← 추가

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late NaverMapController _mapController;
  late List<NMarker> _markers;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(initialCameraPosition: NCameraPosition(target: NLatLng(37.5665, 126.9780), zoom: 15)),
            onMapReady: (controller) {
              _mapController = controller;

              // 마커 준비
              final positions = MarkerService.getMarkerPositions();
              _markers = MarkerService.generateMarkers(positions, context);
              MarkerService.addMarkersToMap(_mapController, _markers);
            },
          ),
          Positioned(top: -20, child: SearchAppbarWidget()),
        ],
      ),
    );
  }
}
