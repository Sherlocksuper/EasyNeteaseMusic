import 'package:flutter/cupertino.dart';

class CommendState {
  PageController pageController = PageController(viewportFraction: 0.90);

  List commandPlayList = [];

  List dailyCommandPlayList = [];

  //歌单分类
  List playListCatList = [];

  //热门歌单分类
  List hotPlayListCatList = [];

  //精品歌单标签列表
  List highqualityPlayListTags = [];

  //**********************************//

  //场景歌单的标签item们
  List scenePlayListTags = [];

  //场景歌单
  List scenePlayList = [];

  //**********************************//

  //心情歌单的标签item们
  List moodPlayListTags = [];

  //心情氛围歌单
  List moodPlayList = [];

  //**********************************//

  //榜单列表
  List topList = [];

  //选择的榜单分类
  List selectTopList = [];

  //**********************************//

  CommendState() {
    ///Initialize variables
  }
}
