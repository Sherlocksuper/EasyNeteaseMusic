import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wyyapp/LoginPrefs.dart';
import 'package:wyyapp/config.dart';
import 'dart:developer';

import 'state.dart';

class MusicPlayLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final MusicPlayState state = MusicPlayState();

  late final AnimationController RController = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();
  final songPlayer = AudioPlayer();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    RController.dispose();
    super.dispose();
  }

  void stopMusic() {
    state.player.stop();
    state.playState = false;
    RController.stop();
    update();
  }

  getSong() async {
    var response = await dio.get("$baseUrl/personalized/newsong");
    log(response.toString());
  }

  //获取歌url
  Future<void> getSongUrl() async {
    var response = await dio.post(
        "$baseUrl/song/url/v1?id=${state.songItem["id"]}&level=exhigh&timestamp=${DateTime.now().millisecondsSinceEpoch}");
    if (response.data["code"] == -462) {
      //把response.data["data"][0]["url"]转化为uri
      var uri = Uri.parse("${response.data["data"]["url"]}");
      log(LoginPrefs.getCookie());
      //携带token
      await launchUrl(uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: WebViewConfiguration(headers: {
            "cookie": LoginPrefs.getCookie(),
            "uid": "1897106867",
            "id": "1897106867",
            "userId": "1897106867"
          }));
    }
    log(response.toString());
  }
}
