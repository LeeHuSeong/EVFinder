import 'package:evfinder/Controller/search_charger_controller.dart';
import 'package:evfinder/Model/search_charger_model.dart';
import 'package:evfinder/View/widget/listtile_ChargerInfo_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/ev_charger_model.dart';
import '../Service/ev_charger_service.dart';
import '../Service/marker_service.dart';

class SearchChargerView extends StatefulWidget {
  const SearchChargerView({super.key});

  @override
  State<SearchChargerView> createState() => _SearchChargerViewState();
}

class _SearchChargerViewState extends State<SearchChargerView> {
  TextEditingController tController = TextEditingController();
  final RxList _searchResult = [].obs;
  List<EvCharger> _chargers = [];
  RxBool isSearched = false.obs;

  Future<void> searchList(String query) async {
    final result = await SearchChargerController.searchUseKeyword(query);
    _searchResult.value = result;
  }

  Future<void> fetchChargers(String query) async {
    final chargers = EvChargerService.fetchChargers(query); // ✅ 임시 query
    _chargers = await chargers;
    isSearched.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: TextFormField(
                onFieldSubmitted: (input) async {
                  searchList(input);
                },
                controller: tController,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchList(tController.text);
                      });
                    },
                    icon: Icon(Icons.search),
                  ),
                  hintText: '충전소 검색',
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),

              // ListTile(
              //   leading: IconButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     icon: Icon(Icons.arrow_back),
              //   ),
              //   trailing: IconButton(
              //     onPressed: () {
              //       setState(() {
              //         searchList(tController.text);
              //       });
              //     },
              //     icon: Icon(Icons.search),
              //   ),
              //   title: TextField(
              //     onSubmitted: (input) async {
              //       searchList(input);
              //     },
              //     controller: tController,
              //     decoration: InputDecoration(hintText: "충전소 검색", border: InputBorder.none),
              //   ),
              // ),
            ),
            Obx(
              () => SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: ListView.separated(
                  itemCount: _searchResult.length,
                  // primary: false,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ListtileChargerinfoWidget(
                      isCancelIconExist: false,
                      name: _searchResult[index].placeName,
                      addr: _searchResult[index].addressName,
                      stat: 0,
                      onTap: () async {
                        // await fetchChargers(_searchResult[index].roadAddressName);
                        Navigator.pop(context, _searchResult[index]);
                      },
                      isStatChip: false,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
