import 'package:evfinder/View/widget/charger_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../Model/ev_charger_model.dart'; // 또는 상대경로 맞게 수정


class MarkerService {
  static List<NMarker> generateMarkers(List<EvCharger> chargers,
      BuildContext context) {
    return chargers.map((charger) {
      final marker = NMarker(
        id: charger.statId,
        position: NLatLng(charger.lat, charger.lng),
        caption: NOverlayCaption(text: charger.name),
      );
      marker.setOnTapListener((NMarker marker) {
        showModalBottomSheet(
          context: context,
          builder: (_) => ChargerDetailCard(charger: charger),
        );
      });
      return marker;
    }).toList();
  }

  static void addMarkersToMap(NaverMapController controller,
      List<NMarker> markers) {
    for (var marker in markers) {
      controller.addOverlay(marker);
    }
  }
}