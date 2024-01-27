import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wyyapp/5my/recently_play/view.dart';

import 'download/view.dart';

class MyState {
  MyState() {
    ///Initialize variables
  }

  Map userDetail = {};

  Map totalInfo = {};

  //用户歌单列表
  List userPlaylist = [];

  //FuncItem列表,包括以上的所有
  List<FunctionItem> functionList = [
    FunctionItem(
        icon: Icons.history,
        title: "最近播放",
        onTap: () {
          Get.to(() => RecentlyPlayPage());
        }),
    FunctionItem(
        icon: Icons.download,
        title: "本地下载",
        onTap: () {
          Get.to(() => DownloadPage());
        }),
    FunctionItem(icon: Icons.cloud, title: "云盘", onTap: () {}),
    FunctionItem(
        icon: Icons.shopping_cart,
        title: "已购",
        onTap: () {
          open();
        }),
    FunctionItem(
        icon: Icons.people,
        title: "我的好友",
        onTap: () {
          open();
        }),
    FunctionItem(
        icon: Icons.favorite,
        title: "收藏和赞",
        onTap: () {
          open();
        }),
    FunctionItem(
        icon: Icons.mic,
        title: "我的播客",
        onTap: () {
          open();
        }),
    FunctionItem(
        icon: Icons.watch_later,
        title: "妙时",
        onTap: () {
          open();
        }),
  ];

  //还未开发
  static void open() {
    EasyLoading.showToast("还未开发", toastPosition: EasyLoadingToastPosition.bottom);
  }
}

//一个类，包括IconDta和onTap方法
class FunctionItem {
  final IconData icon;
  final String title;
  final Function onTap;

  FunctionItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
