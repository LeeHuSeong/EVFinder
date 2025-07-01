import 'package:evfinder/View/widget/listtile_ChargerInfo_widget.dart';
import 'package:flutter/material.dart';

class SearchChargerView extends StatefulWidget {
  const SearchChargerView({super.key});

  @override
  State<SearchChargerView> createState() => _SearchChargerViewState();
}

class _SearchChargerViewState extends State<SearchChargerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                ),
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  trailing: Icon(Icons.search),
                  title: TextField(
                    // onSubmitted: submitted,
                    // controller: controller,
                    decoration: InputDecoration(hintText: "충전소 검색", border: InputBorder.none),
                  ),
                ),
              ),
            ),
            // 검색창 listtile -> 검색 데이터가 아직 적용이 안되서 주석 처리 해놓음
            // SizedBox(
            //   height: MediaQuery
            //       .of(context)
            //       .size
            //       .height * 0.75,
            //   child: ListView.separated(
            //     itemCount: 2,
            //     // primary: false,
            //     physics: AlwaysScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemBuilder: (BuildContext context, int index) {
            //       return ListtileChargerinfoWidget(isCancelIconExist: true, stat:, name:, addr:);
            //     },
            //     separatorBuilder: (BuildContext context, int index) => Divider(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
