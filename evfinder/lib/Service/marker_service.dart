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
  static Set<String> _addedMarkerIds = {}; // ID 추적용

  static List<NMarker> generateMarkers(List<EvCharger> chargers, BuildContext context, NaverMapController nMapController) {
    return chargers.map((charger) {
      final marker = NMarker(
        id: charger.statId,
        position: NLatLng(charger.lat, charger.lng),
        caption: NOverlayCaption(text: charger.name),
      );
      marker.setOnTapListener((NMarker marker) {
        cameraController.moveCameraPosition(charger.lat, charger.lng, nMapController);
        showModalBottomSheet(
          context: context,
          builder: (_) => ChargerDetailCard(charger: charger),
        );
      });
      return marker;
    }).toList();
  }

  static Future<void> addMarkersToMap(NaverMapController controller, List<NMarker> markers) async {
    for (var marker in markers) {
      try {
        await controller.addOverlay(marker);
        _addedMarkerIds.add(marker.info.id);
      } catch (e) {
        print("마커 추가 실패: ${marker.info.id}, 이유: $e");
      }
    }
  }

  static Future<void> removeMarkers(NaverMapController controller, List<NMarker> markers) async {
    for (var marker in List.from(markers)) {
      if (_addedMarkerIds.contains(marker.info.id)) {
        try {
          await controller.deleteOverlay(marker.info);
          _addedMarkerIds.remove(marker.info.id); // 삭제된 것 제거
        } catch (e) {
          print("마커 삭제 실패: ${marker.info.id}, 이유: $e");
        }
      } else {
        print("이미 삭제된 마커 또는 등록되지 않은 마커: ${marker.info.id}");
      }
    }
    markers.clear();
  }

  // static void addMarkersToMap(NaverMapController controller, List<NMarker> markers) {
  //   for (var marker in markers) {
  //     controller.addOverlay(marker);
  //   }
  // }
  //
  // static Future<void> removeMarkers(NaverMapController controller, List<NMarker> markers) async {
  //   for (var marker in List.from(markers)) {
  //     try {
  //       await controller.deleteOverlay(marker.info);
  //     } catch (e) {
  //       print("마커 삭제 실패: ${marker.info.id}, 이유: $e");
  //     }
  //   }
  //   markers.clear(); // 리스트 수정은 반복 이후에!
  // }
}
