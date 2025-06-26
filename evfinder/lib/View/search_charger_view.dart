import 'package:flutter/material.dart';

class SearchChargerView extends StatefulWidget {
  const SearchChargerView({super.key});

  @override
  State<SearchChargerView> createState() => _SearchChargerViewState();
}

class _SearchChargerViewState extends State<SearchChargerView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: []),
    );
  }
}
