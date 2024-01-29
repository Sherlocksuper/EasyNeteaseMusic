import 'dart:developer';
import 'dart:math' hide log;

import 'package:get/get.dart';

import '../config.dart';
import 'state.dart';

class CommendLogic extends GetxController {
  final CommendState state = CommendState();

  static int limit = 6;

  bool initFlag = true;

  Future<void> init() async {
    if (initFlag == false) {
      return;
    }
    log("init");
    log("正在请求推荐歌单");
    await getPlayListCatList();
    log("正在请求热门歌单分类");
    await getHotPlayListCatList();
    log("正在请high");
    await getHighqualityPlayList();
    log("正在请求榜单列表");
    await getTopList();
    await toRefresh();
    initFlag = false;
  }

  //刷新界面
  Future<void> toRefresh() async {
    log("正在刷新界面");
    log("正在请求推荐歌单");
    await getCommandPlayList();
    log("正在请求榜单列表");
    await refreshSelectTopList();
    log("正在请求场景、情感、主题歌单");
    await getTMSPlayList();
    log("正在推荐节目");
    await getProgramRecommend();
    log("正在请求新歌");
    await getNewSong();
    log("正在请求广播");
    await getBroadcast();
    update();
  }

  //获取推荐歌单
  //view的第一部分
  Future<void> getCommandPlayList() async {
    var response = await dio.get("$baseUrl/personalized?limit=$limit");
    if (response.data["code"] == 200) {
      state.functionsMap["commandPlay"]!.list = response.data["result"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //获取榜单列表
  Future<void> getTopList() async {
    var response = await dio.get("$baseUrl/toplist?limit=1");
    if (response.data["code"] == 200) {
      state.topList = response.data["list"];

      state.functionsMap["selectTop"]!.list = createRandomList(state.topList);
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //直接本地刷新
  Future<void> refreshSelectTopList() async {
    state.functionsMap["selectTop"]!.list = createRandomList(state.topList);
  }

  //创建一个随机列表
  List<T> createRandomList<T>(List<T> originalList) {
    // 检查原始列表是否包含至少六个元素
    if (originalList.length < 6) {
      log("Error: 原始列表元素数量不足六个");
      return originalList;
    }

    // 创建一个随机数生成器
    var random = Random();

    Set<int> randomSelection = {};

    // 从原始列表中随机选择六个元素
    while (randomSelection.length < 6) {
      randomSelection.add(random.nextInt(originalList.length));
    }

    List<T> result = [];

    randomSelection.forEach((element) {
      result.add(originalList[element]);
    });

    // 返回新的列表
    return result;
  }

  //普通歌单分类，同时分为 场景、风格、情感
  Future<void> getPlayListCatList() async {
    var response = await dio.get("$baseUrl/playlist/catlist");
    if (response.data["code"] == 200) {
      state.playListCatList = response.data["sub"];
      state.scenePlayListTags = state.playListCatList.where((element) => element["category"] == 2).toList();
      state.moodPlayListTags = state.playListCatList.where((element) => element["category"] == 3).toList();
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //热门歌单分类
  Future<void> getHotPlayListCatList() async {
    var response = await dio.get("$baseUrl/playlist/hot");
    if (response.data["code"] == 200) {
      state.hotPlayListCatList = response.data["tags"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //歌单，网友精选蝶
  Future<List<dynamic>> getNetizenSelected(String tag) async {
    var response = await dio.get("$baseUrl/top/playlist?limit=$limit&cat=$tag");
    if (response.data["code"] == 200) {
      return response.data["playlists"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
    return [];
  }

  //请求场景、情感、主题歌单
  Future<void> getTMSPlayList() async {
    var moodTag = state.moodPlayListTags[Random().nextInt(state.moodPlayListTags.length)]["name"];
    state.functionsMap["moodPlay"]!.list = await getNetizenSelected(moodTag);
    var sceneTag = state.scenePlayListTags[Random().nextInt(state.scenePlayListTags.length)]["name"];
    state.functionsMap["scenePlay"]!.list = await getNetizenSelected(sceneTag);
  }

  //获取精品歌单标签
  Future<void> getHighqualityPlayList() async {
    var response = await dio.get("$baseUrl/playlist/highquality/tags");
    if (response.data["code"] == 200) {
      state.highqualityPlayListTags = response.data["tags"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  Future<void> getHighqualityPlayListByTag(String tag) async {
    var response = await dio.get("$baseUrl/top/playlist/highquality?cat=$tag&limit=$limit");
    if (response.data["code"] == 200) {
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  Future<void> getProgramRecommend() async {
    var response = await dio.get("$baseUrl/program/recommend");
    if (response.data["code"] == 200) {
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //推荐新音乐
  Future<void> getNewSong() async {
    var response = await dio.get("$baseUrl/personalized/newsong?limit=9");
    if (response.data["code"] == 200) {
      state.functionsMap["newSong"]!.list = response.data["result"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //获取广播
  Future<void> getBroadcast() async {
    var response = await dio.get("$baseUrl/personalized/djprogram");
    if (response.data["code"] == 200) {
      // state.broadcastList = response.data["djRadios"];
      state.functionsMap["broadcast"]!.list = response.data["result"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }
}
