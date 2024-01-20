import 'dart:developer';
import 'package:get/get.dart';
import '../config.dart';
import 'state.dart';

class SearchLogic extends GetxController {
  final SearchState state = SearchState();

  //获取默认搜索关键词
  Future<void> getSearchDefault() async {
    var response = await dio.get("$baseUrl/search/default");
    log("获取默认搜索关键词");
    log(response.toString());
    if (response.data["code"] == 200) {
      state.searchDefault = response.data["data"]["showKeyword"];
      update();
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //获取热搜列表
  Future<void> getSearchHotDetail() async {
    var response = await dio.get("$baseUrl/search/hot/detail?timeStamp=${DateTime.now().millisecondsSinceEpoch}");
    log("获取热搜列表");
    log(response.toString());
    if (response.data["code"] == 200) {
      state.searchHotDetail = response.data["data"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }
}
