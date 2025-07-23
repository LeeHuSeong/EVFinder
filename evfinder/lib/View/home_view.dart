import 'package:evfinder/Controller/location_permission_controller.dart';
import 'package:evfinder/Controller/map_camera_controller.dart';
import 'package:evfinder/Service/location_service.dart';
import 'package:evfinder/View/search_charger_view.dart';
import 'package:evfinder/View/widget/search_appbar_widget.dart';
import 'package:evfinder/View/widget/slidingUp_Panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:geolocator/geolocator.dart';
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
  final LocationPermissionController locationController = LocationPermissionController();
  bool isLocationLoaded = false;
  Position? userPosition;
  String addressname = '서울특별시 중구 세종대로 110';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    // 마커는 지도 준비 후 표시됨
  }

  Future<void> _initializeLocation() async {
    try {
      Position? position = await locationController.getCurrentLocation();
      if (mounted) {
        setState(() {
          userPosition = position;
          isLocationLoaded = true;
        });
      }
    } catch (e) {
      print('위치 가져오기 실패: $e');
      if (mounted) {
        setState(() {
          isLocationLoaded = true; // 실패해도 지도는 보여주기
        });
      }
    }
  }

  Future<void> fetchMyChargers(BuildContext context, dynamic result) async {
    if (result != null && result is SearchChargers) {
      // 새 리스트로 fetch
      if (_markers.isNotEmpty) {
        MarkerService.removeMarkers(_nMapController, _markers);
      }
      addressname = result.addressName;
      await fetchChargers(addressname);
      // 마커 새로 로딩
      _loadMarkers(_chargers); // 이 부분 꼭 필요!
      cameraController.moveCameraPosition(double.parse(result.y), double.parse(result.x), _nMapController);
      setState(() {}); // UI 갱신을 위해 필요할 수도 있음
    } else {
      if (isLocationLoaded && locationController.position != null) {
        final addressResultName = LocationService.changeGPStoAddressName(locationController.position!.latitude, locationController.position!.longitude);
        addressname = await addressResultName;
        await fetchChargers(addressname);
      }
    }
  }

  Future<void> fetchChargers(String addressName) async {
    final chargers = EvChargerService.fetchChargers(addressName); // ✅ 임시 query
    _chargers = await chargers;
  }

  Future<void> _loadMarkers(List<EvCharger> chargers) async {
    _markers = await MarkerService.generateMarkers(chargers, context, _nMapController);
    for (var marker in _markers) {
      try {
        await _nMapController.addOverlay(marker);
        await MarkerService.addMarkersToMap(_nMapController, _markers);
      } catch (e) {
        print("마커 추가 실패: ${marker.info.id}, 이유: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    cameraController = MapCameraController();
    if (!isLocationLoaded) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SafeArea(
      child: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: userPosition != null ? NLatLng(userPosition!.latitude, userPosition!.longitude) : const NLatLng(37.5665, 126.9780),
                zoom: 15,
              ),
            ),
            onMapReady: (controller) async {
              if (_isMapReady == false) {
                await fetchMyChargers(context, null);
                _nMapController = controller;
                setState(() {
                  _isMapReady = true;
                });
                _loadMarkers(_chargers); // 서버에서 충전소 받아와서 마커 표시
              }
            },
          ),
          Positioned(
            top: -20,
            child: SearchAppbarWidget(
              onTap: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => SearchChargerView()));
                await fetchMyChargers(context, result);
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
