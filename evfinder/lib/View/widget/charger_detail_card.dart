import 'package:flutter/material.dart';
import '../../Model/ev_charger_model.dart';

class ChargerDetailCard extends StatelessWidget {
  final EvCharger charger;

  const ChargerDetailCard({super.key, required this.charger});

  @override
  Widget build(BuildContext context) {
    final chargerTypeText = _convertChargerType(charger.chgerType);
    final chargerStateText = _convertStatusText(charger.stat);
    final chargerStateColor = _convertStatusColor(charger.stat);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width - 25,
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 충전소 이름
                      Text(charger.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                      /// 주소
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

                  //즐겨찾기 아이콘
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.star, color: Colors.yellow),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 상태 표시 영역
            Container(
              decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 20, right: 16),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 왼쪽: 상태 아이콘 + 타입 텍스트
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

                    /// 오른쪽: 충전 가능 수 (예시)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("충전가능", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        Text("1/2", style: TextStyle(fontWeight: FontWeight.bold)),
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
}
