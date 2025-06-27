import 'package:flutter/material.dart';
import '../Controller/station_controller.dart';
import '../Model/station_model.dart';

class StationListView extends StatefulWidget {
  const StationListView({super.key});

  @override
  State<StationListView> createState() => _StationListViewState();
}

class _StationListViewState extends State<StationListView> {
  final StationController _controller = StationController();
  List<ChargingStation> _stations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    final stations = await _controller.fetchStations();
    setState(() {
      _stations = stations;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('충전소 목록')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _stations.length,
              itemBuilder: (context, index) {
                final station = _stations[index];
                return ListTile(
                  title: Text(station.name),
                  subtitle: Text(
                    '${station.location.latitude}, ${station.location.longitude}',
                  ),
                  onTap: () {
                    // 충전소 상세 이동 or chargers 조회 
                  },
                );
              },
            ),
    );
  }
}
