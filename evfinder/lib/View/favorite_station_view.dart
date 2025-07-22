import 'package:flutter/material.dart';
import 'package:evfinder/Service/favorite_service.dart';
import 'package:evfinder/View/widget/listtitle_Chargestar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteStationView extends StatefulWidget {
  const FavoriteStationView({super.key});

  @override
  State<FavoriteStationView> createState() => _FavoriteStationViewState();
}

class _FavoriteStationViewState extends State<FavoriteStationView> {
  List<Map<String, dynamic>> favoriteStations = [];
  bool isLoading = true;
  late String uid;

  @override
  void initState() {
    super.initState();
    _loadUidAndFavorites();
  }

  Future<void> _loadUidAndFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
    print("현재 uid = ${prefs.getString('uid')}");
    print("현재 userId = ${prefs.getString('userId')}");

    await loadFavoriteStations();
  }

  Future<void> loadFavoriteStations() async {
    setState(() => isLoading = true);

    try {
      // 1. 서버에서 즐겨찾기 목록 + 최신 stat + 거리정보 포함해서 가져오기
      final rawFavorites = await FavoriteService.fetchFavoritesWithStat(uid: uid);

      // 2. 바로 UI에 사용할 수 있도록 매핑
      setState(() {
        favoriteStations = rawFavorites.map((e) {
          return {
            "name": e['name']?.toString() ?? '알 수 없음',
            "addr": e['addr']?.toString() ?? '주소 없음',
            "useTime": e['useTime']?.toString() ?? '',
            "stat": e['stat'] ?? 0,
            "statId": e['statId'],
            'distance': e['distance'] != null
                ? "${double.parse(e['distance'].toString()).toStringAsFixed(1)} km"
                : '',
            "isFavorite": true,
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("즐겨찾기 목록 불러오기 실패: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleFavorite(int index) async {
    final statId = favoriteStations[index]['statId'];

    final success = await FavoriteService.removeFavorite(uid, statId);
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
      appBar: AppBar(title: Text('즐겨찾기 충전소')),
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

      //Refresh버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await loadFavoriteStations();
        },
        child: Icon(Icons.refresh),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }
}
