//封装一个歌曲类
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
  static Duration nowDuration = Duration();

  static PlayerState playerState = PlayerState.stopped;

  //五个state，分别是stopped, playing, paused, completed, disposed

  //初始化监听器
  static initSongModule() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      nowDuration = d;
      Get.find<MusicPlayLogic>().update();
    });

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

  static Future<void> playMusic(Map musicItem) async {
    if (!hasInit) {
      initSongModule();
    }
    musicItemInfo = musicItem;

    log(musicItemInfo.toString());
    //弹出bottomSheet音乐播放界面
    Scaffold.of(sheetContext).showBottomSheet((context) => MusicPlayPage(playItem: musicItemInfo));
    //获取了当前音乐的info，包括url
    musicPlayInfo = await getMusicUrl(musicItemInfo["id"].toString());
    //开始播放
    await audioPlayer.play(UrlSource(musicPlayInfo["url"]));
    //正在播放
    playerState = PlayerState.playing;
  }

  //暂停
  static Future<void> pauseMusic() async {
    if (!hasInit) {
      initSongModule();
    }
    await audioPlayer.pause();
    playerState = PlayerState.paused;
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

    return response.data["data"][0];
  }
}

//当前歌曲质量
enum MusicQuality {
  low,
  medium,
  high,
  exhigh,
}
