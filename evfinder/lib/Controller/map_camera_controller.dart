import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapCameraController {
  Future<void> moveCameraPosition(double lat, double lng, BuildContext context, NaverMapController controller) async {
    final cameraUpdate = NCameraUpdate.withParams(
      target: NLatLng(lat, lng), // 새 위치
      bearing: 0, // 북쪽 방향 고정 (선택)
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
