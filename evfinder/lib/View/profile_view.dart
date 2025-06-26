import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, size: 90),
                SizedBox(width: 40),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("유형우", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                      Text("개발자", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 200,
                        child: Text("프론트엔드, 백엔드, 데이베이스", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400), softWrap: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(thickness: 1.5, endIndent: 20, indent: 20),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 15),
                  child: ListTile(
                    leading: Icon(Icons.star, color: Colors.yellow),
                    title: Text("즐겨찾기"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
