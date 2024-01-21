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
    //推荐歌单的标签
    await getPlayListCatList();
    //热门歌单分类
    await getHotPlayListCatList();
    //精品歌单标签
    await getHighqualityPlayList();
    //榜单
    await getTopList();
    //刷新界面
    await toRefresh();

    initFlag = false;
  }

  //刷新界面
  Future<void> toRefresh() async {
    //获取推荐歌单
    await getCommandPlayList();

    //刷新排行榜
    await refreshSelectTopList();

    //获取三种歌单的推荐歌单
    await getTMSPlayList();

    //获取推荐节目
    await getProgramRecommend();

    update();
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
  //普通歌单分类，同时分为 场景、风格、情感
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
      //读取item中category为4的主题歌单
      state.themePlayListTags = state.playListCatList.where((element) => element["category"] == 4).toList();
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

  //歌单，网友精选蝶
  Future<List<dynamic>> getNetizenSelected(String tag) async {
    var response = await dio.get("$baseUrl/top/playlist?limit=$limit&cat=$tag");
    log("获取网友精选歌单");
    log(response.toString());
    if (response.data["code"] == 200) {
      return response.data["playlists"];
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
    return [];
  }

  //请求场景、情感、主题歌单
  Future<void> getTMSPlayList() async {
    // //从场景标签中随机选取一个
    // var themeTag = state.themePlayListTags[Random().nextInt(state.themePlayListTags.length) - 1]["name"];
    // state.themePlayList = await getDailyCommandPlayList(themeTag);
    // print(themeTag);
    // print(state.themePlayList);
    //从心情标签中随机选取一个
    var moodTag = state.moodPlayListTags[Random().nextInt(state.moodPlayListTags.length)]["name"];
    state.moodPlayList = await getNetizenSelected(moodTag);
    print(moodTag);
    print(state.moodPlayList);
    //从场景标签中随机选取一个
    var sceneTag = state.scenePlayListTags[Random().nextInt(state.scenePlayListTags.length)]["name"];
    state.scenePlayList = await getNetizenSelected(sceneTag);
    print(sceneTag);
    print(state.scenePlayList);
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

  ///program/recommend
  ///获取推荐节目
  Future<void> getProgramRecommend() async {
    var response = await dio.get("$baseUrl/program/recommend");
    log("获取推荐节目");
    log(response.toString());
    log("message");
    log(response.data["programs"][0].toString());
    if (response.data["code"] == 200) {
    } else {
      Get.defaultDialog(title: "错误", middleText: response.data["msg"]);
    }
  }
}
