import 'dart:developer';
import 'package:get/get.dart';
import '../../config.dart';
import 'state.dart';

class OtherUserPageLogic extends GetxController {
  final OtherUserPageState state = OtherUserPageState();

  //获取他人信息
  Future getOtherUserInfo() async {
    log("获取他人信息1");
    var userInfo = await dio.get("$baseUrl/user/detail?uid=${state.userId}");
    state.userInfo = userInfo.data["profile"] as Map<String, dynamic>;
    state.totalInfo = userInfo.data as Map<String, dynamic>;
    update();
  }


  //获取用户歌单
  Future getOtherUserPlayList() async {
    var playList = await dio.get("$baseUrl/user/playlist?uid=${state.userId}");
    state.playList = playList.data["playlist"];
    update();
  }

  //获取用户动态
  Future getOtherUserEvent() async {
    var event = await dio.get("$baseUrl/user/event?uid=${state.userId}");
    state.event = event.data["events"];
    update();
  }
}
