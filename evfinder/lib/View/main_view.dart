import 'package:evfinder/View/profile_view.dart';
import 'package:evfinder/View/search_charger_view.dart';
import 'package:evfinder/View/setting_view.dart';
import 'package:evfinder/View/station_list_view.dart';
import 'package:flutter/material.dart';
import 'package:evfinder/View/favorite_station_view.dart';

import 'home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[FavoriteStationView(), HomeView(), ProfileView()];
    return Scaffold(
      appBar: selectedIndex == 1
          ? null
          : AppBar(
              title: Text("EVFinder"),
              actions: selectedIndex == 2
                  ? [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingView()), // 또는 MainView
                          );
                        },
                        icon: Icon(Icons.settings),
                      ),
                    ]
                  : null,
            ),
      //Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 10,
          child: Padding(
            padding: const EdgeInsets.only(right: 50, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  icon: Icon(Icons.star, size: 35),
                  color: selectedIndex == 0 ? Colors.green : Colors.black12,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  icon: Icon(Icons.person, size: 35),
                  color: selectedIndex == 2 ? Colors.green : Colors.black12,
                ),
              ],
            ),
          ),
        ),
      ),

      // 가운데 동그란 버튼
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          clipBehavior: Clip.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          onPressed: () {
            setState(() {
              selectedIndex = 1;
            });
          },
          backgroundColor: selectedIndex == 1 ? Colors.green : Colors.grey,
          child: Icon(Icons.map, size: 35),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: pages[selectedIndex],
    );
  }
}
