import 'package:evfinder/Controller/map_camera_controller.dart';
import 'package:evfinder/View/widget/charger_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:evfinder/Service/favorite_service.dart';
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

      marker.setOnTapListener((NMarker marker) async {
        cameraController.moveCameraPosition(charger.lat, charger.lng, context, nMapController);

        final statIds = await FavoriteService.getFavoriteStatIds('test_user');

        //디버깅용
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
                  onFavoriteToggle: () async {
                    if (_isFavorite) {
                      await FavoriteService.removeFavorite("test_user", charger.statId);
                    } else {
                      await FavoriteService.addFavorite("test_user", charger);
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

      return marker;
    }).toList();
  }

  static void addMarkersToMap(NaverMapController controller, List<NMarker> markers) {
    for (var marker in markers) {
      controller.addOverlay(marker);
    }
  }
}
