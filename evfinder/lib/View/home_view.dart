import 'package:evfinder/Controller/map_camera_controller.dart';
import 'package:evfinder/View/search_charger_view.dart';
import 'package:evfinder/View/widget/search_appbar_widget.dart';
import 'package:evfinder/View/widget/slidingUp_Panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import '../Model/search_charger_model.dart';
import '../Service/marker_service.dart';
import '../Service/ev_charger_service.dart'; // ✅ 서버 호출용
import '../../Model/ev_charger_model.dart'; // ✅ 모델

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late NaverMapController _nMapController;
  final BoxController _boxController = BoxController();
  late MapCameraController cameraController;
  List<NMarker> _markers = [];
  List<EvCharger> _chargers = [];
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    // 마커는 지도 준비 후 표시됨
  }

  Future<void> fetchSearchResult(BuildContext context, MapCameraController ncController, dynamic result) async {
    if (result != null && result is SearchChargers) {
      // 새 리스트로 fetch
      if (_markers.isNotEmpty) {
        MarkerService.removeMarkers(_nMapController, _markers);
      }

      await fetchChargers(result.addressName);
      // print(double.parse(result.x));
      // print(double.parse(result.y));
      cameraController.moveCameraPosition(double.parse(result.y), double.parse(result.x), _nMapController);

      // 마커 새로 로딩
      _loadMarkers(_chargers); // 이 부분 꼭 필요!

      setState(() {}); // UI 갱신을 위해 필요할 수도 있음
    }
    await fetchChargers("서울특별시 중구 세종대로 110");
  }

  Future<void> fetchChargers(String addressName) async {
    final chargers = EvChargerService.fetchChargers(addressName); // ✅ 임시 query
    _chargers = await chargers;
  }

  /// 🔌 충전소 데이터 가져와서 마커 생성
  // Future<void> _loadMarkers(List<EvCharger> chargers) async {
  //   try {
  //     final markers = MarkerService.generateMarkers(chargers, context, _nMapController);
  //     setState(() {
  //       _markers = markers;
  //     });
  //     MarkerService.addMarkersToMap(_nMapController, _markers);
  //   } catch (e) {
  //     print("마커 로딩 오류: $e");
  //   }
  // }

  Future<void> _loadMarkers(List<EvCharger> chargers) async {
    _markers = MarkerService.generateMarkers(chargers, context, _nMapController);
    for (var marker in _markers) {
      try {
        await _nMapController.addOverlay(marker);
      } catch (e) {
        print("마커 추가 실패: ${marker.info.id}, 이유: $e");
      }
    }
  }

  // Future<void> _loadMarkers() async {
  //   try {
  //     final chargers = await EvChargerService.fetchChargers("서울특별시 중구 세종대로 110"); // ✅ 임시 query
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
    cameraController = MapCameraController();
    return SafeArea(
      child: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(initialCameraPosition: NCameraPosition(target: NLatLng(37.5665, 126.9780), zoom: 15)),
            onMapReady: (controller) async {
              // await fetchSearchResult(context, cameraController, null);
              _nMapController = controller;
              _isMapReady = true;
              _loadMarkers(_chargers); //✅ 서버에서 충전소 받아와서 마커 표시
              // _loadMarkers(); // ✅ 서버에서 충전소 받아와서 마커 표시
            },
          ),
          Positioned(
            top: -20,
            child: SearchAppbarWidget(
              onTap: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => SearchChargerView()));
                await fetchSearchResult(context, cameraController, result);
              },
            ),
          ),
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
