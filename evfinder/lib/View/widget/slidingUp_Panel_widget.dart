import 'package:evfinder/View/widget/listtile_ChargerInfo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';

import '../../Model/ev_charger_model.dart';

class SlidingupPanelWidget extends StatefulWidget {
  const SlidingupPanelWidget({super.key, required this.chargers, required this.nMapController, required this.boxController});

  final List<EvCharger> chargers;
  final NaverMapController nMapController;
  final BoxController boxController;

  @override
  State<SlidingupPanelWidget> createState() => _SlidingupPanelWidgetState();
}

class _SlidingupPanelWidgetState extends State<SlidingupPanelWidget> {
  @override
  Widget build(BuildContext context) {
    //슬라이딩 박스 위젯
    return SlidingBox(
      controller: widget.boxController,
      collapsed: true,
      minHeight: 30,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView.separated(
          itemCount: widget.chargers.length,
          itemBuilder: (context, int index) {
            return ListtileChargerinfoWidget(
              isCancelIconExist: false,
              addr: widget.chargers[index].addr,
              name: widget.chargers[index].name,
              stat: widget.chargers[index].stat,
              lat: widget.chargers[index].lat,
              lng: widget.chargers[index].lng,
              nMapController: widget.nMapController,
              boxController: widget.boxController,
              charger: widget.chargers[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      ),
    );
  }
}
