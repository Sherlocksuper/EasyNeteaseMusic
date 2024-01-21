import 'dart:developer';

import 'package:get/get.dart';
import 'package:wyyapp/config.dart';

import 'state.dart';

class PlayListDetailLogic extends GetxController {
  final PlayListDetailState state = PlayListDetailState();

  //获取歌单详情
  Future getPlayDetail() async {
    log("获取歌单详情");
    var test = await dio.get("$baseUrl/playlist/detail?id=2683713904");

    state.playDetail = test.data["playlist"];

    state.songlist = test.data["playlist"]["tracks"];

    state.creator = test.data["playlist"]["creator"];

    //如果key的值为map，删除这个key
    test.data.removeWhere((key, value) => value.toString().length > 100);

    log(test.toString());

    update();
  }

  //传入一个数字，修改这个数字的形式
  String changeNumber(int number) {
    if (number > 10000) {
      return "${(number / 10000).toStringAsFixed(1)}万";
    } else {
      return number.toString();
    }
  }
}
