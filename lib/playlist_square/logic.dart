import 'dart:developer';

import 'package:get/get.dart';
import '../config.dart';
import 'state.dart';

class PlaylistSquareLogic extends GetxController {
  final PlaylistSquareState state = PlaylistSquareState();

  int limit = 24;

  //"categories":{"0":"语种","1":"风格","2":"场景","3":"情感","4":"主题"}
  Future<void> getPlayListCatList() async {
    if (state.playListCatList.isNotEmpty) {
      return;
    }
    var response = await dio.get("$baseUrl/playlist/catlist");
    log("获取歌单分类");
    log(response.toString());
    if (response.data["code"] == 200) {
      //所有
      state.playListCatList = response.data["sub"];

      //热门
      state.langPlayListTags = state.playListCatList.where((element) => element["category"] == 0).toList();
      state.stylePlayListTags = state.playListCatList.where((element) => element["category"] == 1).toList();
      state.scenePlayListTags = state.playListCatList.where((element) => element["category"] == 2).toList();
      state.moodPlayListTags = state.playListCatList.where((element) => element["category"] == 3).toList();
      state.themePlayListTags = state.playListCatList.where((element) => element["category"] == 4).toList();

      update();
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //歌单 网友精选蝶
  Future<List> getHighqualityPlayListTags(String tag, int offSet) async {
    var response = await dio.get("$baseUrl/top/playlist?cat=$tag&limit=$limit&offset=$offSet");
    log("获取精品歌单标签");
    log(response.toString());
    if (response.data["code"] == 200) {
      return response.data["playlists"] as List;
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
    return [];
  }
}
