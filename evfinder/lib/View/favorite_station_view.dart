import 'package:flutter/material.dart';
import 'package:evfinder/View/widget/listtitle_Chargestar_widget.dart'; 
class FavoriteStationView extends StatefulWidget {
  const FavoriteStationView({super.key});

  @override
  State<FavoriteStationView> createState() => _FavoriteStationViewState();
}

class _FavoriteStationViewState extends State<FavoriteStationView> {
  List<Map<String, dynamic>> favoriteStations = [
    {
      'stationName': '서울역 전기차 충전소',
      'stationAddress': '서울특별시 중구 한강대로 405',
      'operatingHours': '24시간',
      'chargerStat': 1,
      'distance': '1.2km',
      'isFavorite': true,
    },
    {
      'stationName': '강남역 지하 충전소',
      'stationAddress': '서울특별시 강남구 강남대로 396',
      'operatingHours': '06:00-22:00',
      'chargerStat': 0,
      'distance': '2.8km',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기 충전소'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: favoriteStations.length,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final station = favoriteStations[index];
                    return ListtileChargestarWidget(
                      stationName: station['stationName'],
                      stationAddress: station['stationAddress'],
                      operatingHours: station['operatingHours'],
                      chargerStat: station['chargerStat'],
                      distance: station['distance'],
                      isFavorite: station['isFavorite'],
                      onFavoriteToggle: () {
                        setState(() {
                          favoriteStations[index]['isFavorite'] =
                              !favoriteStations[index]['isFavorite'];
                        });
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
