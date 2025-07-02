import 'package:evfinder/Controller/map_camera_controller.dart';
import 'package:evfinder/View/widget/charger_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../Model/ev_charger_model.dart'; // 또는 상대경로 맞게 수정

class MarkerService {
  // //이 코드는 Listtile ChargerInfo Widget에서도 사용하고 있음.
  // Future<void> moveCameraPosition(double lat, double lng, BuildContext context, NaverMapController controller) async {
  //   final cameraUpdate = NCameraUpdate.withParams(
  //     target: NLatLng(lat, lng), // 새 위치
  //     bearing: 0, // 북쪽 방향 고정 (선택)
  //   );
  //   if (controller != null) {
  //     // await controller.moveCamera(CameraUpdate.scrollTo(LatLng(lat, lng)));
  //     // await controller.latLngToScreenLocation(NLatLng(lat, lng));
  //     // await controller.updateCamera(cameraUpdate);
  //     controller.updateCamera(cameraUpdate);
  //
  //     // Navigator.pop(context);
  //   }
  // }

  static MapCameraController cameraController = MapCameraController();

  static List<NMarker> generateMarkers(List<EvCharger> chargers, BuildContext context, NaverMapController nMapController) {
    return chargers.map((charger) {
      final marker = NMarker(
        id: charger.statId,
        position: NLatLng(charger.lat, charger.lng),
        caption: NOverlayCaption(text: charger.name),
      );
      marker.setOnTapListener((NMarker marker) {
        cameraController.moveCameraPosition(charger.lat, charger.lng, context, nMapController);
        showModalBottomSheet(
          context: context,
          builder: (_) => ChargerDetailCard(charger: charger),
        );
      });
      return marker;
    }).toList();
  }

  static void addMarkersToMap(NaverMapController controller, List<NMarker> markers) {
    for (var marker in markers) {
      controller.addOverlay(marker);
    }
  }
}
