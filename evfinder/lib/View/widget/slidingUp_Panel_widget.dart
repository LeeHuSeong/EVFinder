import 'package:evfinder/View/widget/listtile_ChargerInfo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/map_camera_controller.dart';
import '../../Model/ev_charger_model.dart';
import '../../Service/favorite_service.dart';
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
  String _uid = '';
  @override
  void initState() {
    super.initState();
    _loadUid();
  }

  //uid 가져오기
  Future<void> _loadUid() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = prefs.getString('uid') ?? '';
    });
  }

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
                final statIds = await FavoriteService.getFavoriteStatIds('test_user');
                final isFavorite = statIds.contains(widget.chargers[index].statId);
                showModalBottomSheet(
                  context: context,
                  builder: (_) => ChargerDetailCard(
                      charger: widget.chargers[index],
                      isFavorite: isFavorite,
                      uid :_uid,
                  ),
                );
              },
              isStatChip: true,
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      ),
    );
  }
}
