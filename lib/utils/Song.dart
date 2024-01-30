import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  //当前歌曲歌词
  static List<dynamic> songLyric = [];

  static FixedExtentScrollController lyricController = FixedExtentScrollController();

  //**********************下载数据********************** */

  //初始化监听器
  //五个state，分别是stopped, playing, paused, completed, disposed
  static initSongModule() {
    Get.put(MusicPlayLogic());
    audioPlayer.onPositionChanged.listen((event) {
      log(event.toString());
      nowProgress = event;
      Get.find<MusicPlayLogic>().update(["progress"]);

      //歌词滚动
      if (songLyric.isNotEmpty) {
        for (int i = 0; i < songLyric.length; i++) {
          if (i == songLyric.length - 1) {
            // lyricController.jumpToItem(i);
            lyricController.animateToItem(i, duration: const Duration(milliseconds: 200), curve: Curves.ease);
            break;
          }
          if (event.inMilliseconds >= songLyric[i]["time"].inMilliseconds &&
              event.inMilliseconds < songLyric[i + 1]["time"].inMilliseconds) {
            lyricController.animateToItem(i, duration: const Duration(milliseconds: 200), curve: Curves.ease);
            break;
          }
        }
      }
    });

    audioPlayer.onDurationChanged.listen((Duration d) {});

    audioPlayer.onPlayerComplete.listen((event) {
      //根据三种状态选择不同的模式
      if (playMode == PlayMode.loop) {
        resumeMusic();
      } else if (playMode == PlayMode.order) {
        playNextMusic();
      } else if (playMode == PlayMode.random) {
        playRandomMusic();
      }
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
    if (!hasInit) initSongModule();

    if (musicItemInfo["id"] == musicItem["id"]) {
      //如果等于的话，就直接打开播放页
      Get.bottomSheet(
        SizedBox(
          height: Get.height,
          child: MusicPlayPage(),
        ),
        isScrollControlled: true,
      );
      continueMusic();
      return;
    }

    //如果musicItem不在预备播放列表里面，就添加进去
    if (!songListToPlay.contains(musicItem)) addSongToPreparePlayList(musicItem);

    clearData();

    musicItemInfo = musicItem;

    if (Get.isBottomSheetOpen == false) {
      Get.bottomSheet(
        SizedBox(
          height: Get.height,
          child: MusicPlayPage(),
        ),
        isScrollControlled: true,
      );
    }

    Get.find<MusicPlayLogic>().update();

    //获取了当前音乐的info，包括url
    musicPlayInfo = await getMusicUrl(musicItemInfo["id"].toString());
    songLyric = await getMusicLyric(musicItemInfo["id"].toString());

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

    int index = songListToPlay.indexOf(musicItemInfo);
    if (index == songListToPlay.length - 1) {
      await playMusic(songListToPlay[0]);
    } else {
      await playMusic(songListToPlay[index + 1]);
    }
  }

  //播放上一首歌
  static Future<void> playPreviousMusic() async {
    if (!hasInit) {
      initSongModule();
    }

    int index = songListToPlay.indexOf(musicItemInfo);
    if (index == 0) {
      EasyLoading.showToast("已经是第一首了哦~");
    } else {
      await playMusic(songListToPlay[index - 1]);
    }
  }

  //随机播放一首歌
  static Future<void> playRandomMusic() async {
    if (!hasInit) {
      initSongModule();
    }
    int index = Random().nextInt(songListToPlay.length);
    await playMusic(songListToPlay[index]);
  }

  //添加歌曲到下一首播放
  static void addSongToNextPlay(Map musicItem) {
    songListToPlay.insert(songListToPlay.indexOf(musicItemInfo) + 1, musicItem);
  }

  //添加歌曲到最后播放
  static void addSongToLastPlay(Map musicItem) {
    songListToPlay.add(musicItem);
  }

  //**************操作数据***************** */

  //清空 进度 、播放状态 、转圈
  static void clearData() {
    nowProgress = Duration(seconds: 0);
    playerState = PlayerState.stopped;
    audioPlayer.stop();
    songLyric = [];
    Get.find<MusicPlayLogic>().RController.stop();
    Get.find<MusicPlayLogic>().update();
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

  //获取歌曲详情
  static Future<Map> getMusicDetail(String id) async {
    var response = await dio.get("$baseUrl/song/detail?ids=$id");
    return response.data["songs"][0];
  }

  //获取歌曲歌词
  static Future<List<dynamic>> getMusicLyric(String id) async {
    var response = await dio.get("$baseUrl/lyric?id=$id");
    List lyricList = response.data["lrc"]["lyric"].split("\n");

    log("message");
    log(lyricList.toString());

    List<dynamic> result = [];

    for (var item in lyricList) {
      if (item == "") {
        continue;
      }
      List<String> tempList = item.split("]");
      result.add({
        "time": Duration(
            minutes: int.parse(tempList[0].substring(1, 3)),
            seconds: int.parse(tempList[0].substring(4, 6)),
            milliseconds: int.parse(tempList[0].substring(7, 9))),
        "lyric": tempList[1],
      });
    }

    return result;
  }

  //**************操作列表***************** */

  //添加歌曲到预备播放列表
  static void addSongToPreparePlayList(Map musicItem) {
    //判断是否有id一样的歌曲
    for (var element in songListToPlay) {
      if (element["id"] == musicItem["id"]) {
        return;
      }
    }

    songListToPlay.add(musicItem);
  }

  //把歌曲从预备播放列表移除
  static void removeSongFromPreparePlayList(Map musicItem) {
    //如果只有一首
    if (songListToPlay.length == 1) {
      EasyLoading.showToast("只剩一首歌了哦~ 不能再删了哦~");
      return;
    }

    if (musicItem == musicItemInfo) {
      playNextMusic();
    }
    songListToPlay.remove(musicItem);
    Get.find<MusicPlayLogic>().update();
  }

  //************歌曲的下载操作和属性************** */

  //首先要挑选一个文件，存储音乐的item信息下载到的路径
  //然后要挑选一个文件，存储音乐的url资源信息

  //下载歌曲资源的路径,这里是固定的app下的文件夹,存放mp3
  static String musicDownloadPath = "songs";

  //数据存储的路径,存储在外部存储的文件夹
  static String musicDataPath = "data";

  //待下载列表
  static List<Map> downloadList = [];

  //基础读写操作

  //下载歌曲  传入 确定的文件名称和url
  static Future<bool> downloadSong(String name, String url) async {
    return await FileManager.downLoad(musicDownloadPath, name, "mp3", url);
  }

  //通过id下载歌曲,因为部分展示的歌曲没有url，所以需要先获取url
  static Future<bool> downloadSongById(String id) async {
    bool result = false;

    Map targetItemInfo = await getMusicDetail(id);
    Map targetPlayInfo = await getMusicUrl(id);

    String targetUrl = targetPlayInfo["url"];

    //文件名
    String name = DateTime.timestamp().toString();
    result = await downloadSong(name, targetUrl);

    return result;
  }

  //删除歌曲
  static Future<bool> deleteSong(String path) async {
    return await FileManager.deleteFile(path);
  }

  static void seekMusic(double d) {
    audioPlayer.seek(Duration(milliseconds: (d * totalLength.inMilliseconds).toInt()));
  }
}

class LocalSong {
  List<Map> songList = [];

  LocalSong.fromJson(Map<String, dynamic> json) {
    if (json['songList'] != null) {
      songList = [];
      json['songList'].forEach((v) {
        songList.add(Map<String, dynamic>.from(v));
      });
    }
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

//{name: Do That, id: 2118458192, pst: 0, t: 0, ar: [{id: 51957057, name: ljz329, tns: [], alias: []}, {id: 1132392, name: 马思唯, tns: [], alias: []}], alia: [], pop: 100, st: 0, rt: , fee: 8, v: 4, crbt: null, cf: ,
// al: {id: 183494872, name: Do That, picUrl: http://p2.music.126.net/Q3p_jBF64PDmBZz6oSnVpg==/109951169268410736.jpg, tns: [], pic_str: 109951169268410736, pic: 109951169268410740}, dt: 184421,
// h: {br: 320000, fid: 0, size: 7379113, vd: -68512}, m: {br: 192000, fid: 0, size: 4427485, vd: -65895}, l: {br: 128000, fid: 0, size: 2951671, vd: -64166}, sq: {br: 1546481, fid: 0, size: 35650471, vd: -68501},
// hr: null, a: null, cd: 01, no: 1, rtUrl: null, ftype: 0, rtUrls: [], djId: 0, copyright: 0, s_id: 0, mark: 17179877376, originCoverType: 1, originSongSimpleData: null, tagPicList: null, resourceState: true, version: 4,
// songJumpInfo: null, entertainmentTags: null, awardTags: null, single: 0, noCopyrightRcmd: null, rtype: 0, rurl: null, mst: 9, cp: 0, mv: 0, publishTime: 1705680000000}

//循环、顺序、随机
enum PlayMode {
  loop,
  order,
  random,
}
