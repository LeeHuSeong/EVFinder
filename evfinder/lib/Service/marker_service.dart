import 'package:flutter_naver_map/flutter_naver_map.dart';

class MarkerService {
  static List<NLatLng> getMarkerPositions() {
    return [
      //NLatLng(36.992381, 127.728582), // 한국 교통대
      NLatLng(37.565694,126.977139),
      // 다른 좌표도 여기에 추가 가능
    ];
  }

  static List<NMarker> generateMarkers(List<NLatLng> positions) {
    return List.generate(positions.length, (index) {
      final marker = NMarker(
        id: 'marker_$index',
        position: positions[index],
        caption: NOverlayCaption(text: '충전소 #$index'),
      );
      return marker;
    });
  }

  static void addMarkersToMap(
      NaverMapController controller, List<NMarker> markers) {
    for (var marker in markers) {
      controller.addOverlay(marker);
    }
  }
}
