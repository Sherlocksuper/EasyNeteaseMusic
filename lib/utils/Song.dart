import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:path_provider/path_provider.dart';
import 'package:wyyapp/utils.dart';
import 'package:wyyapp/utils/FileManager.dart';
import '../LoginPrefs.dart';
import '../config.dart';
import '../music_play/logic.dart';
import '../music_play/view.dart';
import 'package:dio/dio.dart';

class SongManager {
  //歌曲队列
  //音乐详情,不包括url
  static bool hasInit = false;

  //音乐详情,不包括url
  static Map musicItemInfo = {};

  //音乐详情,包括url
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

  //通过url下载歌曲，不传url则默认下载当前歌曲
  static Future<bool> downloadSongByUrl({String? url}) async {
    var result = false;
    String targetUrl = url ?? musicPlayInfo["url"];
    result = await FileManager.downLoad("song", musicItemInfo["name"], "mp3", targetUrl);
    return result;
  }

  //通过id下载歌曲,因为部分展示的歌曲没有url，所以需要先获取url
  static Future<bool> downloadSongById(String id) async {
    bool result = false;

    String targetUrl = (await getMusicUrl(id))["url"];
    result = await downloadSongByUrl(url: targetUrl);

    return result;
  }

  //获取下载了的所有歌曲
  static Future<List<Map>> getDownloadedSong() async {
    List<Map> songList = await FileManager.listFiles("song");
    return songList;
  }

  //删除歌曲
  static Future<bool> deleteSong(String path) async {
    return await FileManager.deleteFile(path);
  }
}

//当前歌曲质量
enum MusicQuality {
  low,
  medium,
  high,
  exhigh,
}

//playInfo  其余在musicItemInfo
// [log] {id: 2115507066, url: http://m801.music.126.net/20240127122201/2e376cdde98660894a75cfc5e710694d/jdymusic/obj/wo3DlMOGwrbDjj7DisKw/32666442213/8d1a/b7ef/ed0a/7d89a9fabf16eecd1113da0bc84fefc4.mp3,
// br: 320000, size: 8377005, md5: 7d89a9fabf16eecd1113da0bc84fefc4, code: 200, expi: 1200,
// type: mp3, gain: -8.0895, peak: 1, fee: 8, uf: null, payed: 1, flag: 462852, canExtend: false,
// freeTrialInfo: null, level: exhigh, encodeType: mp3, channelLayout: null,
// freeTrialPrivilege: {resConsumable: false, userConsumable: false, listenType: null, cannotListenReason: null, playReason: null},
// freeTimeTrialPrivilege: {resConsumable: false, userConsumable: false, type: 0, remainTime: 0},
// urlSource: 0, rightSource: 0, podcastCtrp: null, effectTypes: null, time: 209375}

//musicItemInfo
//{id: 2117905342, type: 4, name: 共鸣, copywriter: null, picUrl: http://p1.music.126.net/kDKdNs8hv9aThGKNMtWx1g==/109951169282470776.jpg, canDislike: false, trackNumberUpdateTime: null,
// song: {name: 共鸣, id: 2117905342, position: 0, alias: [仙剑六影视剧《祈今朝》独爱片尾主题曲], status: 0, fee: 8, copyrightId: 0, disc: 01, no: 1, artists: [{name: 周深, id: 1030001, picId: 0, img1v1Id: 0, briefDesc: , picUrl: ,
// img1v1Url: http://p3.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg, albumSize: 0, alias: [], trans: , musicSize: 0, topicPerson: 0}], album: {name: 共鸣, id: 183332158, type: Single, size: 1, picId: 109951169282470780, blurPicUrl: http://p4.music.126.net/kDKdNs8hv9aThGKNMtWx1g==/109951169282470776.jpg, companyId: 0, pic: 109951169282470780, picUrl: http://p3.music.126.net/kDKdNs8hv9aThGKNMtWx1g==/109951169282470776.jpg, publishTime: 1706112000000, description: , tags: ,
// company: 网易·云上 X 网易音乐人, briefDesc: , artist: {name: , id: 0, picId: 0, img1v1Id: 0, briefDesc: , picUrl: , img1v1Url: http://p4.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg, albumSize: 0,
// alias: [], trans: , musicSize: 0, topicPerson: 0}, songs: [], alias: [仙剑六影视剧《祈今朝》独爱片尾主题曲], status: 1, copyrightId: -1, commentThreadId: R_AL_3_183332158, artists: [{name: 周深, id: 1030001, picId: 0,
// img1v1Id: 0, briefDesc: , picUrl: , img1v1Url: http://p3.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg, albumSize: 0, alias: [], trans: , musicSize: 0, topicPerson: 0}], subType: 录音室版, transName: null, onSale: false, mark: 0, gapless: 0, picId_str: 109951169282470776}, starred: false, popularity: 100, score: 100, starredNum: 0, duration: 215463, playedNum: 0, dayPlays: 0, hearTime: 0, sqMusic: {name: null, id: 8789524643, size: 22595730, extension: flac, sr: 48000, dfsId: 0, bitrate: 838962, playTime: 215463, volumeDelta: -9006}, hrMusic: {name: null, id: 8789524642, size: 43306703, extension: flac, sr: 48000, dfsId: 0, bitrate: 1607944, playTime: 215463, volumeDelta: -8912}, ringtone: , crbt: null, audition: null, copyFrom: , commentThreadId: R_SO_4_2117905342, rtUrl:
