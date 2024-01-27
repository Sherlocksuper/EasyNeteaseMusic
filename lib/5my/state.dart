import 'package:flutter/material.dart';

class MyState {
  MyState() {
    ///Initialize variables
  }

  Map userDetail = {};

  Map totalInfo = {};

  Map<String, IconData> iconList = {
    //最近播放
    "最近播放": Icons.history,
    //本地下载
    "本地下载": Icons.download,
    //云盘
    "云盘": Icons.cloud,
    //已购
    "已购": Icons.shopping_cart,
    //我的好友
    "我的好友": Icons.people,
    //收藏和赞
    "收藏和赞": Icons.favorite,
    //我的播客
    "我的播客": Icons.mic,
    //妙时
    "妙时": Icons.watch_later,
  };
}
