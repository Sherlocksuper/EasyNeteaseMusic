import 'package:flutter/cupertino.dart';

class CommendState {
  PageController pageController = PageController(viewportFraction: 0.90);

  //歌单分类
  List playListCatList = [];

  //热门歌单分类
  List hotPlayListCatList = [];

  //精品歌单标签列表
  List highqualityPlayListTags = [];

  //**********************************//

  //场景歌单的标签item们
  List scenePlayListTags = [];

  //**********************************//

  //心情歌单的标签item们
  List moodPlayListTags = [];

  //榜单列表
  List topList = [];


  //广播
  List broadcastList = [];

  Map<String, FunctionList> functionsMap = {
    "commandPlay": FunctionList("推荐歌单", "card", []),
    "newSong": FunctionList("新歌推荐", "tile", []),
    "selectTop": FunctionList("排行榜", "card", []),
    "moodPlay": FunctionList("心情歌单", "card", []),
    "scenePlay": FunctionList("场景歌单", "card", []),
    "broadcast": FunctionList("广播", "card", []),
  };

  CommendState();
}

class FunctionList {
  String title;
  String type;
  List list;

  FunctionList(this.title, this.type, this.list);
}
