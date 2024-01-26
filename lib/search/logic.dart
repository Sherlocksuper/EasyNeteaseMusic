import 'dart:developer';
import 'package:get/get.dart';
import '../config.dart';
import 'state.dart';

class SearchLogic extends GetxController {
  final SearchState state = SearchState();

  //获取默认搜索关键词
  Future<void> getSearchDefault() async {
    var response = await dio.get("$baseUrl/search/default");
    state.searchDefault = response.data["data"]["showKeyword"];
  }

  //获取热搜列表
  Future<void> getSearchHotList() async {
    var response = await dio.get("$baseUrl/search/hot/detail?timeStamp=${DateTime.now().millisecondsSinceEpoch}");
    state.searchHotList = response.data["data"];
  }

  //搜索 通过type获取搜索结果
  Future<void> getSearchResult(String key) async {
    String keywords = state.searchKeyword == "" ? state.searchDefault : state.searchKeyword;
    state.searchKeyword = keywords;
    int type = state.searchTypes[key]!.type;

    var response = await dio.get("$baseUrl/cloudsearch?keywords=$keywords&type=$type");
    state.searchTypes[key]!.result = response.data["result"][key];

    update(["searchResult"]);
  }

  Future<void> getSearchSuggest(String keywords) async {
    if (keywords == "") {
      state.searchSuggest = [];
      update(["searchSuggest"]);
      return;
    }

    var response = await dio.get("$baseUrl/search/suggest?keywords=$keywords&type=mobile");
    state.searchSuggest = response.data["result"]["allMatch"];
    update(["searchSuggest"]);
  }
}
