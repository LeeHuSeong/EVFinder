import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class MapCameraController {

  Future<void> moveCameraPosition(double lat, double lng, NaverMapController controller) async {

    final cameraUpdate = NCameraUpdate.withParams(
      target: NLatLng(lat, lng), // 새 위치
      bearing: 0, // 북쪽 방향 고정 (선택)
      zoom: 15,
    );
    if (controller != null) {
      // await controller.moveCamera(CameraUpdate.scrollTo(LatLng(lat, lng)));
      // await controller.latLngToScreenLocation(NLatLng(lat, lng));
      // await controller.updateCamera(cameraUpdate);
      controller.updateCamera(cameraUpdate);

      // Navigator.pop(context);
    }
  }
}
