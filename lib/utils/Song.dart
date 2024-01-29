import 'dart:developer';
import 'dart:html';
import 'dart:math' hide log;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:wyyapp/utils/FileManager.dart';
import '../LoginPrefs.dart';
import '../config.dart';
import '../music_play/logic.dart';
import '../music_play/view.dart';

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

  //音乐模式 循环播放、顺序播放、随机播放
  static PlayMode playMode = PlayMode.order;

  //预备播放歌曲列表 ,存取音乐item
  static List<Map> songListToPlay = [];

  //初始化监听器
  //五个state，分别是stopped, playing, paused, completed, disposed
  static initSongModule() {
    audioPlayer.onPositionChanged.listen((event) {
      log(event.toString());
      nowProgress = event;
      Get.find<MusicPlayLogic>().update(["progress"]);
    });

    audioPlayer.onDurationChanged.listen((Duration d) {});

    audioPlayer.onPlayerComplete.listen((event) {
      playMode == PlayMode.loop ? resumeMusic() : playNextMusic();
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

  //**************基础播放操作***************** */

  //播放
  static Future<void> playMusic(Map musicItem) async {
    if (!hasInit) {
      initSongModule();
    }

    //如果musicItem不在预备播放列表里面，就添加进去
    if (!songListToPlay.contains(musicItem)) {
      addSongToPreparePlayList(musicItem);
    }

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
    //获取总时长
    totalLength = (await audioPlayer.getDuration())!;
    //正在播放
    playerState = PlayerState.playing;
    //刷新
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

  //播放下一首歌
  static Future<void> playNextMusic() async {
    if (!hasInit) {
      initSongModule();
    }
    //如果是随机播放

    if (playMode == PlayMode.random) {
      int index = Random().nextInt(songListToPlay.length);
      await playMusic(songListToPlay[index]);
    } else {
      int index = songListToPlay.indexOf(musicItemInfo);
      if (index == songListToPlay.length - 1) {
        await playMusic(songListToPlay[0]);
      } else {
        await playMusic(songListToPlay[index + 1]);
      }
    }
  }

  //**************操作数据***************** */

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

  //直接下载当前歌曲
  static Future<bool> downloadCurrentSong() async {
    var result = false;

    Map targetItemInfo = await getMusicDetail(musicItemInfo["id"].toString());
    Map targetPlayInfo = await getMusicUrl(musicItemInfo["id"].toString());

    String targetUrl = musicPlayInfo["url"];
    String name = MusicDLInfo(targetItemInfo, targetPlayInfo).getMusicPath();
    result = await FileManager.downLoad("song", name, "mp3", targetUrl);
    return result;
  }

  //通过id下载歌曲,因为部分展示的歌曲没有url，所以需要先获取url
  static Future<bool> downloadSongById(String id) async {
    bool result = false;

    Map targetItemInfo = await getMusicDetail(id);
    Map targetPlayInfo = await getMusicUrl(id);

    String targetUrl = (await getMusicUrl(id))["url"];
    String name = MusicDLInfo(targetItemInfo, targetPlayInfo).getMusicPath();
    result = await FileManager.downLoad("song", name, "mp3", targetUrl);
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

  //获取歌曲详情
  static Future<Map> getMusicDetail(String id) async {
    var response = await dio.get("$baseUrl/song/detail?ids=$id");
    return response.data["songs"][0];
  }

  //**************操作列表***************** */

  //添加歌曲到预备播放列表
  static void addSongToPreparePlayList(Map musicItem) {
    songListToPlay.add(musicItem);
  }

  //把歌曲从预备播放列表移除
  static void removeSongFromPreparePlayList(Map musicItem) {
    songListToPlay.remove(musicItem);
  }
}

class MusicDLInfo {
  String musicName = "";
  String musicAuthor = "";
  String musicDesc = "";
  String musicBitrate = "";

  //初始化的时候要传入item和play
  MusicDLInfo(Map itemInfo, Map playInfo) {
    log(itemInfo.toString());
    musicName = itemInfo["name"] ?? "名称未知";
    musicAuthor = (itemInfo["song"]?["artists"] ?? itemInfo["ar"] as List).map((e) => e["name"]).toList().join(" ");
    musicDesc = itemInfo["alias"]?.toString() ?? "暂无描述";
    musicBitrate = playInfo["br"].toString();
  }

  //fromString
  MusicDLInfo.fromString(String path) {
    List<String> pathList = path.split(" ");
    musicName = pathList[0];
    musicAuthor = pathList[1];
    musicDesc = pathList[2];
    musicBitrate = pathList[3];
  }

  //下载的时候返回拼接的String
  String getMusicPath() {
    return "$musicName & $musicAuthor & $musicDesc & $musicBitrate";
  }
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

//循环、顺序、随机
enum PlayMode {
  loop,
  order,
  random,
}
