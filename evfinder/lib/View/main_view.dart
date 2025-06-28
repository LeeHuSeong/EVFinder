import 'package:evfinder/View/profile_view.dart';
import 'package:evfinder/View/search_charger_view.dart';
import 'package:evfinder/View/setting_view.dart';
import 'package:evfinder/View/station_list_view.dart';
import 'package:flutter/material.dart';

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
    List<Widget> pages = <Widget>[StationListView(), HomeView(), ProfileView(), SettingView()];
    return Scaffold(
      appBar: selectedIndex == 1 ? null : AppBar(title: Text("EVFinder")),
      //Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 10,
          child: Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  icon: Icon(Icons.star, size: 25),
                  color: selectedIndex == 0 ? Colors.green : Colors.black12,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  icon: Icon(Icons.explore, size: 25),
                  color: selectedIndex == 1 ? Colors.green : Colors.black12,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  icon: Icon(Icons.person, size: 25),
                  color: selectedIndex == 2 ? Colors.green : Colors.black12,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                  },
                  icon: Icon(Icons.settings, size: 25),
                  color: selectedIndex == 3 ? Colors.green : Colors.black12,
                ),
              ],
            ),
          ),
        ),
      ),

      // 가운데 동그란 버튼
      // floatingActionButton: SizedBox(
      //   height: 80,
      //   width: 80,
      //   child: FloatingActionButton(
      //     clipBehavior: Clip.none,
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      //     onPressed: () {
      //       setState(() {
      //         selectedIndex = 1;
      //       });
      //     },
      //     backgroundColor: selectedIndex == 1 ? Colors.green : Colors.grey,
      //     child: Icon(Icons.map, size: 35),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: pages[selectedIndex],
    );
  }
}
