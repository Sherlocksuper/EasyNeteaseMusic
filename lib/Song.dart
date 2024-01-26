//封装一个歌曲类
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wyyapp/utils.dart';

import 'LoginPrefs.dart';
import 'config.dart';
import 'music_play/logic.dart';
import 'music_play/view.dart';

class SongManager {
  //歌曲队列
  //音乐详情,不包括url
  static bool hasInit = false;
  static Map musicItemInfo = {};
  static Map musicPlayInfo = {};
  static AudioPlayer audioPlayer = AudioPlayer();
  static Duration nowProgress = Duration(seconds: 0);
  static Duration totalLength = Duration();
  static PlayerState playerState = PlayerState.stopped;

  //五个state，分别是stopped, playing, paused, completed, disposed
  //初始化监听器
  static initSongModule() {
    audioPlayer.onPositionChanged.listen((event) {
      log(event.toString());
      nowProgress = event;
      Get.find<MusicPlayLogic>().update(["progress"]);
    });

    audioPlayer.onDurationChanged.listen((Duration d) {});

    audioPlayer.onPlayerComplete.listen((event) {
      audioPlayer.play(UrlSource(musicPlayInfo["url"]));
    });

    //当播放状态改变的时候
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.playing) {
        playerState = PlayerState.playing;
      } else if (event == PlayerState.paused) {
        playerState = PlayerState.paused;
      } else if (event == PlayerState.stopped) {
        playerState = PlayerState.stopped;
      } else if (event == PlayerState.completed) {
        playerState = PlayerState.completed;
      } else if (event == PlayerState.disposed) {
        playerState = PlayerState.disposed;
      }
      Get.find<MusicPlayLogic>().update();
    });

    hasInit = true;
  }

  //播放
  static Future<void> playMusic(Map musicItem) async {
    if (!hasInit) {
      initSongModule();
    }
    //如果音乐相同，不做处理

    musicItemInfo = musicItem;

    Get.bottomSheet(
      SizedBox(
        height: Get.height,
        child: MusicPlayPage(),
      ),
      isScrollControlled: true,
    );

    //获取了当前音乐的info，包括url
    musicPlayInfo = await getMusicUrl(musicItemInfo["id"].toString());
    //开始播放
    await audioPlayer.play(UrlSource(musicPlayInfo["url"]));

    totalLength = (await audioPlayer.getDuration())!;
    //正在播放
    playerState = PlayerState.playing;

    Get.find<MusicPlayLogic>().RController.repeat();

    Get.find<MusicPlayLogic>().update();
  }

  //暂停
  static Future<void> pauseMusic() async {
    if (!hasInit) {
      initSongModule();
    }
    await audioPlayer.pause();
    playerState = PlayerState.paused;
    Get.find<MusicPlayLogic>().RController.stop();
  }

  //继续播放
  static Future<void> continueMusic() async {
    if (!hasInit) {
      initSongModule();
    }

    await audioPlayer.resume();
    playerState = PlayerState.playing;
    Get.find<MusicPlayLogic>().RController.repeat();
  }

  //从头播放
  static Future<void> resumeMusic() async {
    if (!hasInit) {
      initSongModule();
    }
    await audioPlayer.seek(const Duration(seconds: 0));
    playerState = PlayerState.playing;
    //刷新
    Get.find<MusicPlayLogic>().update();
  }

  //清空数据
  static void clearData() {
    musicItemInfo = {};
    musicPlayInfo = {};
    nowProgress = Duration(seconds: 0);
    totalLength = Duration();
    playerState = PlayerState.stopped;
  }

  //这里只会返回一个Map
  static Future<Map> getMusicUrl(String id) async {
    if (!hasInit) {
      initSongModule();
    }
    dio.options.headers["cookie"] = LoginPrefs.getCookie();
    var response =
        await dio.get("$baseUrl/song/url/v1?id=$id&level=exhigh&timeStamp=${DateTime.now().millisecondsSinceEpoch}");
    log(response.toString());

    if (response.data["code"] == -462) {
      Get.defaultDialog(title: "错误", middleText: "验证错误");
    } else if (response.data["code"] == -460) {
      Get.defaultDialog(title: "错误", middleText: "网络拥挤");
    }

    return response.data["data"][0];
  }

  static Future<bool> downloadSongByUrl(String? url) async {
    //目标url
    String targetUrl = url ?? musicPlayInfo["url"];
    //是否下载成功
    bool result = await downLoadFile(targetUrl);

    return result;
  }

  static Future<bool> downloadSongById(String id) async {
    //目标url
    String targetUrl = (await getMusicUrl(id))["url"];
    //是否下载成功
    bool result = await downLoadFile(targetUrl);

    return result;
  }
}

//当前歌曲质量
enum MusicQuality {
  low,
  medium,
  high,
  exhigh,
}
