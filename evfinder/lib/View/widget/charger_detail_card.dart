import 'package:flutter/material.dart';
import '../../Model/ev_charger_model.dart';
import 'package:evfinder/Service/favorite_service.dart';

class ChargerDetailCard extends StatefulWidget {
  final EvCharger charger;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ChargerDetailCard({
    super.key,
    required this.charger,
    required this.isFavorite,
    this.onFavoriteToggle,
  });

  @override
  State<ChargerDetailCard> createState() => _ChargerDetailCardState();
}

//충전 상태 보여주기 위함 함수
String _getAvailabilityText(int stat) {
  return stat == 2 ? '1/1' : '0/1';
}

class _ChargerDetailCardState extends State<ChargerDetailCard> {
  late bool isFavorite = false;
  final String userId = 'test_user'; // 나중에 SharedPreferences로 대체

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    refreshStat();
  }

  //stat만 불러옴(1,2,3)등의 값
  Future<void> refreshStat() async {
    try {
      final updatedStat = await FavoriteService.fetchStat(widget.charger.statId);
      setState(() {
        widget.charger.stat = updatedStat;
      });
    } catch (e) {
      print("⚠️ stat 최신화 실패: $e");
    }
  }

  Future<void> toggleFavorite() async {
    if (isFavorite) {
      final success = await FavoriteService.removeFavorite(userId, widget.charger.statId);
      if (success) {
        setState(() => isFavorite = false);
        showSnackBar("즐겨찾기에서 제거되었습니다.");
      } else {
        showSnackBar("제거 실패");
      }
    } else {
      final success = await FavoriteService.addFavorite(userId, widget.charger);
      if (success) {
        setState(() => isFavorite = true);
        showSnackBar("즐겨찾기에 추가되었습니다.");
      } else {
        showSnackBar("추가 실패");
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final charger = widget.charger;
    final chargerTypeText = _convertChargerType(charger.chgerType);
    final chargerStateColor = _convertStatusColor(charger.stat);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width - 25,
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 이름, 주소, 즐겨찾기 버튼
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 이름 + 주소
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(charger.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Text(
                          charger.addr,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // 즐겨찾기 아이콘
                  IconButton(

                    onPressed: toggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 하단: 상태, 타입 등
            Container(
              decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 20, right: 16),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          CircleAvatar(radius: 6, backgroundColor: chargerStateColor),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              chargerTypeText,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              charger.output,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 오른쪽 충전 가능 수
                    //Stat값에 따라 텍스트 설정
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("충전가능", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text(_getAvailabilityText(charger.stat), style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
