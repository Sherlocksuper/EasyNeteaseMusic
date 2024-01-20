import 'dart:developer';
import 'dart:math' hide log;

import 'package:get/get.dart';

import '../config.dart';
import 'state.dart';

class CommendLogic extends GetxController {
  final CommendState state = CommendState();

  static int limit = 6;

  Future<void> init() async {
    //推荐歌单
    await getPlayListCatList();
    //热门歌单分类
    await getHotPlayListCatList();
    //精品歌单标签
    await getHighqualityPlayList();
    //榜单
    await getTopList();
    //刷新界面
    await toRefresh();
  }

  //刷新界面
  Future<void> toRefresh() async {
    await getCommandPlayList();
    await refreshSelectTopList();
    await getHighqualityPlayListByTag("浪漫");
    update();

    //心情歌单
    log(state.moodPlayListTags.toString());
    //场景歌单
    log(state.scenePlayList.toString());

  }

  //获取推荐歌单
  //view的第一部分
  Future<void> getCommandPlayList() async {
    var response = await dio.get("$baseUrl/personalized?limit=$limit");
    log("获取推荐歌单");
    log(response.toString());
    if (response.data["code"] == 200) {
      state.commandPlayList = response.data["result"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //获取榜单列表
  Future<void> getTopList() async {
    var response = await dio.get("$baseUrl/toplist?limit=1");
    log("获取榜单");
    log(response.toString());
    if (response.data["code"] == 200) {
      state.topList = response.data["list"];
      state.selectTopList = createRandomList(state.topList);
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //刷新选择的榜单
  //直接本地刷新
  Future<void> refreshSelectTopList() async {
    state.selectTopList = createRandomList(state.topList);
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

  //"categories":{"0":"语种","1":"风格","2":"场景","3":"情感","4":"主题"}
  //获取歌单分类
  Future<void> getPlayListCatList() async {
    var response = await dio.get("$baseUrl/playlist/catlist");
    log("获取歌单分类");
    log(response.toString());
    if (response.data["code"] == 200) {
      state.playListCatList = response.data["sub"];

      //读取item中category为2的场景歌单
      state.scenePlayListTags = state.playListCatList.where((element) => element["category"] == 2).toList();
      //读取item中category为3的情感歌单
      state.moodPlayListTags = state.playListCatList.where((element) => element["category"] == 3).toList();
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //热门歌单分类
  Future<void> getHotPlayListCatList() async {
    var response = await dio.get("$baseUrl/playlist/hot");
    log("获取热门歌单分类");
    log(response.toString());
    if (response.data["code"] == 200) {
      state.hotPlayListCatList = response.data["tags"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //获取精品歌单标签
  Future<void> getHighqualityPlayList() async {
    var response = await dio.get("$baseUrl/playlist/highquality/tags");
    log("获取精品歌单标签");
    log(response.toString());
    if (response.data["code"] == 200) {
      state.highqualityPlayListTags = response.data["tags"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }

  //获取精品歌单
  Future<void> getHighqualityPlayListByTag(String tag) async {
    var response = await dio.get("$baseUrl/top/playlist/highquality?cat=$tag&limit=$limit");
    log("获取精品$tag歌单");
    log(response.toString());
    if (response.data["code"] == 200) {
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }
}
