import 'package:evfinder/View/widget/search_appbar_widget.dart';
import 'package:evfinder/View/widget/slidingUp_Panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import '../Service/marker_service.dart';
import '../Service/ev_charger_service.dart'; // ✅ 서버 호출용
import '../../Model/ev_charger_model.dart'; // ✅ 모델
import '../Service/ev_charger_service.dart';
import '../../Model/ev_charger_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late NaverMapController _nMapController;
  final BoxController _boxController = BoxController();
  List<NMarker> _markers = [];
  List<EvCharger> _chargers = [];
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    // 마커는 지도 준비 후 표시됨
  }

  Future<void> fetchChargers() async {
    final chargers = EvChargerService.fetchChargers("서울특별시 중구 세종대로 110");
    _chargers = await chargers;
  }

  /// 충전소 데이터 가져와서 마커 생성
  Future<void> _loadMarkers(List<EvCharger> chargers) async {
    try {
      final markers = MarkerService.generateMarkers(chargers, context, _nMapController);
      setState(() {
        _markers = markers;
      });
      MarkerService.addMarkersToMap(_nMapController, _markers);
    } catch (e) {
      print("마커 로딩 오류: $e");
    }
  }

  // Future<void> _loadMarkers() async {
  //   try {
  //     final chargers = await EvChargerService.fetchChargers("서울특별시 중구 세종대로 110");
  //     final markers = MarkerService.generateMarkers(chargers, context);
  //     setState(() {
  //       _markers = markers;
  //     });
  //     MarkerService.addMarkersToMap(_mapController, _markers);
  //   } catch (e) {
  //     print("마커 로딩 오류: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(initialCameraPosition: NCameraPosition(target: NLatLng(37.5665, 126.9780), zoom: 15)),
            onMapReady: (controller) async {
              await fetchChargers();
              _nMapController = controller;
              _isMapReady = true;
              _loadMarkers(_chargers); // 서버에서 충전소 받아와서 마커 표시
              // _loadMarkers(); // 서버에서 충전소 받아와서 마커 표시
            },
          ),
          Positioned(top: -20, child: SearchAppbarWidget()),
          _isMapReady
              ? Positioned(
            bottom: 0,
            child: SlidingupPanelWidget(chargers: _chargers, nMapController: _nMapController, boxController: _boxController),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}