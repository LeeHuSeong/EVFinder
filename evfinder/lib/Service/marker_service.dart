import 'package:evfinder/Controller/map_camera_controller.dart';
import 'package:evfinder/View/widget/charger_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:evfinder/Service/favorite_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/ev_charger_model.dart'; // 또는 상대경로 맞게 수정

class MarkerService {
  static MapCameraController cameraController = MapCameraController();
  static Set<String> _addedMarkerIds = {}; // ID 추적용
  static Future<List<NMarker>> generateMarkers(List<EvCharger> chargers, BuildContext context, NaverMapController nMapController)
  async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid') ?? '';

    return chargers.map((charger) {
      final marker = NMarker(
        id: charger.statId,
        position: NLatLng(charger.lat, charger.lng),
        caption: NOverlayCaption(text: charger.name),
      );

      marker.setOnTapListener((NMarker marker) async {
        cameraController.moveCameraPosition(charger.lat, charger.lng, nMapController);

        final statIds = await FavoriteService.getFavoriteStatIds(uid);

        // 디버깅용 출력
        print("📌 charger.statId = ${charger.statId} (${charger.statId.runtimeType})");
        print("📋 Favorite statIds = $statIds");

        final isFavorite = statIds.contains(charger.statId.toString());

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                bool _isFavorite = isFavorite;

                return ChargerDetailCard(
                  charger: charger,
                  isFavorite: _isFavorite,
                  uid: uid,
                  onFavoriteToggle: () async {
                    if (_isFavorite) {
                      await FavoriteService.removeFavorite(uid, charger.statId);
                    } else {
                      await FavoriteService.addFavorite(uid, charger);
                    }
                    setModalState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                );
              },
            );
          },
        );
      });

      return marker; // ❗❗ 여기 반드시 필요함
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
}
