import 'package:evfinder/View/search_charger_view.dart';
import 'package:flutter/material.dart';

class SearchAppbarWidget extends StatelessWidget {
  const SearchAppbarWidget({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('위치, 충전소 검색', style: TextStyle(color: Colors.black12)),
                const Icon(Icons.search, color: Colors.black12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
