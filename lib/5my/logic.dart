import 'dart:developer';

import 'package:get/get.dart';
import '../LoginPrefs.dart';
import '../config.dart';
import '../login/view.dart';
import 'state.dart';

class MyLogic extends GetxController {
  final MyState state = MyState();

  //获取用户信息
  Future<Map> getUserDetail(int userId) async {
    var userDetail = await dio.get("$baseUrl/user/detail?uid=$userId");
    return userDetail.data;
  }

  //获取歌手信息
  Future<Map> getArtistDetail(int artistId) async {
    var artistDetail = await dio.get("$baseUrl/artist/detail?id=$artistId");
    return artistDetail.data["data"];
  }

  //获取用户歌单
  Future getOtherUserPlayList(int userId) async {
    var playList = await dio.get("$baseUrl/user/playlist?uid=$userId");
    update();
  }

  //获取用户动态
  Future getOtherUserEvent(int userId) async {
    var event = await dio.get("$baseUrl/user/event?uid=$userId");
    update();
  }

  //退出登录
  Future<void> logout() async {
    LoginPrefs.clear();
    Get.offAll(() => LoginPage());
  }
}
