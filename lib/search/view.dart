import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wyyapp/config.dart';
import 'package:wyyapp/search/result.dart';
import 'package:wyyapp/search/suggest.dart';
import 'package:wyyapp/search/top.dart';
import 'logic.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final logic = Get.put(SearchLogic());
  final state = Get.find<SearchLogic>().state;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() async => {await logic.getSearchDefault(), await logic.getSearchHotList()}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 40,
            title: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              child: GetBuilder<SearchLogic>(
                builder: (controller) {
                  return TextField(
                    onChanged: (value) {
                      state.searchKeyword = value;
                      controller.getSearchSuggest(value);
                    },
                    decoration: InputDecoration(
                      hintText: state.searchDefault,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.to(() => const SearchResultPage());
                },
                child: const Text(
                  "搜索",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GetBuilder<SearchLogic>(
              id: "searchSuggest",
              builder: (logic) {
                if (state.searchSuggest.isEmpty || state.searchKeyword == "") {
                  return const SearchBody();
                } else {
                  return Padding(padding: const EdgeInsets.only(left: 10, right: 10), child: SearchSuggestList());
                }
              },
            ),
          ),
        );
      },
    );
  }
}
