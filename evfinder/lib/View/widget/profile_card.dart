import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) =>));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.account_circle, size: 90, color: Colors.grey),
            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("user", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  Text("test123@naver.com", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  // SizedBox(
                  //   width: 200,
                  //   child: Text("===설명===", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400), softWrap: true),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
