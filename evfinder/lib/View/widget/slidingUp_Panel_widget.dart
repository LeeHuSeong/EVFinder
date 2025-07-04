import 'package:evfinder/View/widget/listtile_ChargerInfo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';

import '../../Controller/map_camera_controller.dart';
import '../../Model/ev_charger_model.dart';
import 'charger_detail_card.dart';

class SlidingupPanelWidget extends StatefulWidget {
  const SlidingupPanelWidget({super.key, required this.chargers, required this.nMapController, required this.boxController});

  final List<EvCharger> chargers;
  final NaverMapController nMapController;
  final BoxController boxController;

  @override
  State<SlidingupPanelWidget> createState() => _SlidingupPanelWidgetState();
}

class _SlidingupPanelWidgetState extends State<SlidingupPanelWidget> {
  static MapCameraController cameraController = MapCameraController();

  @override
  Widget build(BuildContext context) {
    //슬라이딩 박스 위젯
    return SlidingBox(
      controller: widget.boxController,
      collapsed: true,
      minHeight: 30,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.53,
        child: ListView.separated(
          itemCount: widget.chargers.length,
          itemBuilder: (context, int index) {
            return ListtileChargerinfoWidget(
              isCancelIconExist: false,
              addr: widget.chargers[index].addr,
              name: widget.chargers[index].name,
              stat: widget.chargers[index].stat,
              onTap: () async {
                widget.boxController.closeBox();
                cameraController.moveCameraPosition(widget.chargers[index].lat, widget.chargers[index].lng, widget.nMapController);
                // moveCameraPosition(widget.lat, widget.lng, context, widget.nMapController);
                showModalBottomSheet(
                  context: context,
                  builder: (_) => ChargerDetailCard(charger: widget.chargers[index]),
                );
              }, isStatChip: true,
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      ),
    );
  }
}
