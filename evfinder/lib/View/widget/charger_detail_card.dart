import 'package:flutter/material.dart';
import '../../Model/ev_charger_model.dart';
import 'package:evfinder/Service/favorite_service.dart';

class ChargerDetailCard extends StatefulWidget {
  final EvCharger charger;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  final String uid;

  const ChargerDetailCard({
    super.key,
    required this.charger,
    required this.isFavorite,
    required this.uid,
    this.onFavoriteToggle,
  });

  @override
  State<ChargerDetailCard> createState() => _ChargerDetailCardState();
}

class _ChargerDetailCardState extends State<ChargerDetailCard> {
  late bool _isFavorite;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _toggleFavorite() async {
    if (_isProcessing) return;//중복 방지
    _isProcessing = true;

    try {
      if (_isFavorite) {
        await FavoriteService.removeFavorite(widget.uid, widget.charger.statId);
      } else {
        await FavoriteService.addFavorite(widget.uid, widget.charger);
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });

      // if (widget.onFavoriteToggle != null) {
      //   widget.onFavoriteToggle!();
      // }
    } catch (e) {
      print(" 즐겨찾기 처리 오류: $e");
    } finally {
      _isProcessing = false;
    }
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
                  IconButton(
                    onPressed: _isProcessing ? null : _toggleFavorite, // 처리 중이면 비활성화
                    icon: Icon(
                      _isFavorite ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 하단 상태
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
                          Flexible(child: Text(chargerTypeText, style: const TextStyle(fontWeight: FontWeight.bold))),
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

  String _getAvailabilityText(int stat) {
    return stat == 2 ? '1/1' : '0/1';
  }

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
