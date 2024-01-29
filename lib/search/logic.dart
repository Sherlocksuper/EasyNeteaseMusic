import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/play_list_detail/view.dart';
import 'package:wyyapp/5my/userartist.dart';
import 'package:wyyapp/5my/userpage.dart';
import 'package:wyyapp/utils/Song.dart';
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
    log("搜索关键词：${state.searchKeyword}");
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

  ManageOnClick(String name, var item) {
    switch (name) {
      case "songs":
        log("播放歌曲${item["name"]}，id为${item["id"]}");
        SongManager.playMusic(item);
        break;
      case "albums":
        Get.toNamed("/album");
        break;
      case "artists":
        log(item["id"].toString());
        Get.to(() => ArtistPage(userId: item["id"]));
        break;
      case "playlists":
        Get.to(() => PlayListDetailPage(playListId: item["id"]));
        break;
      case "userprofiles":
        log(item.toString());
        // Get.to(() => UsePage(userId: item["userId"], type: 'user'), preventDuplicates: false);
        break;
      case "mv":
        Get.toNamed("/mv");
        break;
      case "djRadios":
        Get.toNamed("/dj");
        break;
      case "video":
        Get.toNamed("/video");
        break;
      default:
        break;
    }
  }
}
