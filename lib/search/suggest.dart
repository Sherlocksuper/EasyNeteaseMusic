import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wyyapp/search/result.dart';

import 'logic.dart';

class SearchSuggestList extends StatelessWidget {
  SearchSuggestList({super.key});

  final logic = Get.find<SearchLogic>();
  final state = Get.find<SearchLogic>().state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.searchSuggest.length,
      itemBuilder: (context, index) {
        return searchSuggestItem(state.searchSuggest[index]);
      },
    );
  }

  Widget searchSuggestItem(var item) {
    return GestureDetector(
      onTap: () async {
        state.searchKeyword = item["keyword"];
        Get.to(() => const SearchResultPage());
      },
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            const Gap(10),
            Text(
              item["keyword"],
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
