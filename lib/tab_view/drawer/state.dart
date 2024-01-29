import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wyyapp/LoginPrefs.dart';

import '../../utils.dart';

class CommandDrawerState {
  CommandDrawerState() {
    ///Initialize variables
  }

  List<FunctionItem> functionList = [
    FunctionItem(FunctionType.me, icon: Icons.email_outlined, title: "我的消息", onTap: open),
    FunctionItem(FunctionType.me, icon: Icons.verified_user_outlined, title: "会员中心", onTap: open),
    // FunctionItem(FunctionType.service, icon: Icons.emoji_objects_outlined, title: "趣测", onTap: open),
    // FunctionItem(FunctionType.service, icon: Icons.emoji_objects_outlined, title: "云村有票", onTap: open),
    // FunctionItem(FunctionType.service, icon: Icons.shopping_bag_outlined, title: "商城", onTap: open),
    // FunctionItem(FunctionType.service, icon: Icons.music_note_outlined, title: "Beat专区", onTap: open),
    // FunctionItem(FunctionType.service, icon: Icons.music_note_outlined, title: "音乐收藏家", onTap: open),
    // FunctionItem(FunctionType.service, icon: Icons.video_collection_outlined, title: "视频彩铃", onTap: () {}),
    FunctionItem(FunctionType.other, icon: Icons.settings_outlined, title: "设置", onTap: () {}),
    FunctionItem(FunctionType.other, icon: Icons.nights_stay_outlined, title: "深色模式", onTap: () {
      Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    }),
    FunctionItem(FunctionType.other, icon: Icons.timer_outlined, title: "定时关闭", onTap: () {}),
    // FunctionItem(FunctionType.other, icon: Icons.emoji_objects_outlined, title: "个性装扮", onTap: () {}),
    FunctionItem(FunctionType.other, icon: Icons.download_outlined, title: "边听边存", onTap: () {}),
    FunctionItem(FunctionType.other, icon: Icons.wifi_outlined, title: "在线听歌免流量", onTap: () {}),
    // FunctionItem(FunctionType.other, icon: Icons.music_note_outlined, title: "音乐黑名单", onTap: () {}),
    // FunctionItem(FunctionType.other, icon: Icons.child_care_outlined, title: "青少年模式", onTap: () {}),
    // FunctionItem(FunctionType.other, icon: Icons.alarm_outlined, title: "音乐闹钟", onTap: () {}),
    FunctionItem(FunctionType.myApp, icon: Icons.info_outlined, title: "关于", onTap: LoginPrefs.logout),
    // FunctionItem(FunctionType.myApp, icon: Icons.apps_outlined, title: "我的小程序", onTap: () {}),
    FunctionItem(FunctionType.myApp, icon: Icons.exit_to_app_outlined, title: "退出", onTap: LoginPrefs.showAppData),
  ];
}

class FunctionItem {
  final IconData icon;
  final String title;
  final Function onTap;
  final FunctionType type;

  FunctionItem(
    this.type, {
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

enum FunctionType {
  me,
  service,
  other,
  myApp,
}
