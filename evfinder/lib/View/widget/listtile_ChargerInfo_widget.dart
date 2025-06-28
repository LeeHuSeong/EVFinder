import 'package:flutter/material.dart';

class ListtileChargerinfoWidget extends StatelessWidget {
  const ListtileChargerinfoWidget({super.key, required this.chargerStat});

  final int chargerStat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Station Name", style: TextStyle(fontWeight: FontWeight.w700)),
                          SizedBox(width: 20),
                          Chip(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // 더 크게 할수록 더 둥글어짐
                            ),
                            visualDensity: VisualDensity.compact,
                            labelPadding: EdgeInsets.all(2.0),
                            label: Text("충전 불가능", style: TextStyle(color: Colors.white, fontSize: 10)),
                            backgroundColor: chargerStat == 0 ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                      Text("Station Address", style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.close)),
            ],
          ),
        ), // ListTile(
        //   leading: Icon(Icons.map),
        //   title: Text("Station Name"),
        //   subtitle: Text(" Address", style: TextStyle(fontSize: 13)),
        // ),
      ),
    );
  }
}
