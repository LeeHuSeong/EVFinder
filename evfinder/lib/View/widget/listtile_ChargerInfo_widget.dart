import 'package:evfinder/Controller/map_camera_controller.dart';
import 'package:evfinder/View/widget/slidingUp_Panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';

import '../../Model/ev_charger_model.dart';
import 'charger_detail_card.dart';

class ListtileChargerinfoWidget extends StatefulWidget {
  const ListtileChargerinfoWidget({
    super.key,
    required this.isCancelIconExist,
    required this.name,
    required this.addr,
    required this.stat,
    required this.lat,
    required this.lng,
    required this.nMapController,
    required this.boxController,
    required this.charger,
  });

  final bool isCancelIconExist;
  final String name;
  final String addr;
  final int stat;
  final double lat;
  final double lng;
  final NaverMapController nMapController;
  final BoxController boxController;
  final EvCharger charger;

  @override
  State<ListtileChargerinfoWidget> createState() => _ListtileChargerinfoWidgetState();
}

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

class _ListtileChargerinfoWidgetState extends State<ListtileChargerinfoWidget> {
  static MapCameraController cameraController = MapCameraController();

  @override
  Widget build(BuildContext context) {
    //검색창 및 슬라이딩 박스에 있는 listtile 하나
    return GestureDetector(
      onTap: () async {
        widget.boxController.closeBox();
        cameraController.moveCameraPosition(widget.lat, widget.lng, context, widget.nMapController);
        // moveCameraPosition(widget.lat, widget.lng, context, widget.nMapController);
        showModalBottomSheet(
          context: context,
          builder: (_) => ChargerDetailCard(charger: widget.charger),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.name, style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(widget.addr, style: TextStyle(fontSize: 13, overflow: TextOverflow.fade)),
                      ),
                    ],
                  ),
                ],
              ),
              Chip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // 더 크게 할수록 더 둥글어짐
                ),
                visualDensity: VisualDensity.compact,
                labelPadding: EdgeInsets.all(2.0),
                label: Text(_convertStatusText(widget.stat), style: TextStyle(color: Colors.white, fontSize: 10)),
                backgroundColor: _convertStatusColor(widget.stat),
              ),
              widget.isCancelIconExist ? IconButton(onPressed: () {}, icon: Icon(Icons.close)) : SizedBox.shrink(),
            ],
          ),
        ), // ListTile(
        //   leading: Icon(Icons.map),
        //   title: Text("Station Name"),
        //   subtitle: Text(" Address", style: TextStyle(fontSize: 13)),
        // ),
      ),
    );
  }
}

/// 충전기 타입 코드 → 텍스트
String _convertChargerType(String code) {
  switch (code) {
    case "01":
      return "완속";
    case "02":
      return "급속";
    case "03":
      return "초급속";
    case "06":
      return "DC차데모";
    case "07":
      return "AC3상";
    default:
      return "기타";
  }
}

/// 상태 코드 → 텍스트
String _convertStatusText(int stat) {
  switch (stat) {
    case 1:
      return "통신이상";
    case 2:
      return "충전대기";
    case 3:
      return "충전중";
    case 4:
      return "운영중지";
    case 5:
      return "점검중";
    default:
      return "상태미정";
  }
}

/// 상태 코드 → 색상
Color _convertStatusColor(int stat) {
  switch (stat) {
    case 2:
      return Colors.green; // 충전 가능
    case 3:
      return Colors.orange; // 충전 중
    case 4:
    case 5:
      return Colors.red; // 오류 상태
    default:
      return Colors.grey;
  }
}
