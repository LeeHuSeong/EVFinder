import 'package:evfinder/View/widget/profile_card.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ProfileCard(), //지금은 하드 코딩 되어있음.
          SizedBox(height: 20),
          Divider(thickness: 1.5, endIndent: 20, indent: 20),
          SingleChildScrollView(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 20.0, top: 15),
                //   child: ListTile(
                //     leading: Icon(Icons.star, color: Colors.yellow),
                //     title: Text("즐겨찾기"),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
