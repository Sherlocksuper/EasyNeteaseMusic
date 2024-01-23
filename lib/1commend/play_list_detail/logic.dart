import 'dart:developer';

import 'package:get/get.dart';
import 'package:wyyapp/config.dart';

import 'state.dart';

class PlayListDetailLogic extends GetxController {
  final PlayListDetailState state = PlayListDetailState();

  //获取歌单详情
  Future getPlayDetail() async {
    var test = await dio.get("$baseUrl/playlist/detail?id=${state.playListId}");
    state.playDetail = test.data["playlist"];
    state.songlist = test.data["playlist"]["tracks"];
    state.creator = test.data["playlist"]["creator"];

    //如果key的值为map，删除这个key
    test.data.removeWhere((key, value) => value.toString().length > 100);
    log(test.toString());

    update();
  }


}
