import 'package:flutter/material.dart';
import 'package:evfinder/Service/favorite_service.dart';
import 'package:evfinder/Service/ev_charger_service.dart';
import 'package:evfinder/View/widget/listtitle_Chargestar_widget.dart';

class FavoriteStationView extends StatefulWidget {
  const FavoriteStationView({super.key});

  @override
  State<FavoriteStationView> createState() => _FavoriteStationViewState();
}

class _FavoriteStationViewState extends State<FavoriteStationView> {
  List<Map<String, dynamic>> favoriteStations = [];
  bool isLoading = true;
  final String userId = 'test_user'; // 나중에 SharedPreferences로 대체

  @override
  void initState() {
    super.initState();
    loadFavoriteStations();
  }

  Future<void> loadFavoriteStations() async {
    setState(() => isLoading = true);

    try {
      const double lat = 37.5665;
      const double lng = 126.9780;

      // 1. DB에서 즐겨찾기 목록 가져오기
      final rawFavorites = await FavoriteService.fetchFavoritesWithStat(
        userId: userId,
        lat: lat,
        lng: lng,
      );

      // 2. stat 갱신 및 정규화 (2, 3만 이용 가능으로 처리)
      final updatedFavorites = await Future.wait(rawFavorites.map((e) async {
        try {
          final stat = await FavoriteService.fetchStat(e['statId']);
          e['stat'] = (stat == 2 || stat == 3) ? 1 : 0; // ✅ 1: 가능, 0: 불가
        } catch (_) {
          e['stat'] = 0;
        }
        return e;
      }));

      // 3. 화면에 표시할 데이터로 변환
      setState(() {
        print("🎯 즐겨찾기 개수: ${rawFavorites.length}");
        favoriteStations = updatedFavorites.map((e) {
          return {
            "name": e['name'],
            "addr": e['addr'],
            "useTime": e['useTime'],
            "stat": e['stat'], // 이미 1 또는 0으로 정규화됨
            "statId": e['statId'],
            "distance": '${e['distance']}km',
            "isFavorite": true,
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("❌ 즐겨찾기 목록 불러오기 실패: $e");
      setState(() => isLoading = false);
    }
  }



  Future<void> toggleFavorite(int index) async {
    final statId = favoriteStations[index]['statId'];

    // 즐겨찾기 해제 요청
    final success = await FavoriteService.removeFavorite(userId, statId);
    if (success) {
      setState(() {
        favoriteStations.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("즐겨찾기에서 제거됨")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("즐겨찾기 제거 실패")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기 충전소'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: favoriteStations.length,
                  itemBuilder: (context, index) {
                    final station = favoriteStations[index];
                    return ListtileChargestarWidget(
                      stationName: station['name'],
                      stationAddress: station['addr'],
                      operatingHours: station['useTime'] ?? '',
                      chargerStat: station['stat'],
                      distance: station['distance'] ?? '',
                      isFavorite: station['isFavorite'],
                      onFavoriteToggle: () => toggleFavorite(index),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
