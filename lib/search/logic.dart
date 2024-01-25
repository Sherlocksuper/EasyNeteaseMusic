import 'dart:developer';
import 'package:get/get.dart';
import 'package:wyyapp/search/view.dart';
import '../config.dart';
import 'state.dart';

class SearchLogic extends GetxController {
  final SearchState state = SearchState();

  //获取默认搜索关键词
  Future<void> getSearchDefault() async {
    var response = await dio.get("$baseUrl/search/default");
    log("获取默认搜索关键词");
    log(response.toString());
    state.searchDefault = response.data["data"]["showKeyword"];
  }

  //获取热搜列表
  Future<void> getSearchHotList() async {
    var response = await dio.get("$baseUrl/search/hot/detail?timeStamp=${DateTime.now().millisecondsSinceEpoch}");
    log("获取热搜列表");
    log(response.toString());
    state.searchHotList = response.data["data"];
  }

  //搜索   /song/url  参数keywords
  Future<void> getSearchResult(String keywords) async {
    var response = await dio.get("$baseUrl/search?keywords=$keywords");
  }

  //搜索  多重匹配
  Future<void> getSearchMultimatch(String keywords) async {
    var response = await dio.get("$baseUrl/search/multimatch?keywords=$keywords");
  }

  //获取搜索建议
  Future<void> getSearchSuggest(String keywords) async {
    var response = await dio.get("$baseUrl/search/suggest?keywords=$keywords&type=mobile");
    log("获取搜索建议");
    log(response.toString());
    state.searchSuggest = response.data["result"]["allMatch"];
    update(["searchSuggest"]);
  }
}
