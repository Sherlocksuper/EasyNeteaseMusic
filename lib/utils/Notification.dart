import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wyyapp/utils/Song.dart';

class NotificationManager {
  static bool hasInit = false;

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static AndroidInitializationSettings initAndroidSetting = const AndroidInitializationSettings('app_icon');

  static InitializationSettings initSetting = InitializationSettings(android: initAndroidSetting);

  static init() async {
    if (await Permission.notification.request().isGranted) {}

    flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (notification) async {
        switch (notification.actionId) {
          case '上一首':
            SongManager.playNextMusic();
            break;
          case '切换播放状态':
            if (SongManager.playerState == PlayerState.playing) {
              SongManager.pauseMusic();
            } else {
              SongManager.continueMusic();
            }
            break;
          case '下一首':
            SongManager.playNextMusic();
            break;
        }

        log('onDidReceiveNotificationResponse');
      },
    );

    hasInit = true;
  }

  ///**********************************
  static displayNotification() async {
    if (!hasInit) await init();

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'play',
      '仿网易云app',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        const AndroidNotificationAction(
          '上一首',
          '上一首',
          allowGeneratedReplies: true,
          cancelNotification: false,
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          //切换播放状态
          '切换播放状态',
          '切换播放状态',
          allowGeneratedReplies: true,
          cancelNotification: false,
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          '下一首',
          '下一首',
          allowGeneratedReplies: true,
          cancelNotification: false,
          showsUserInterface: true,
        ),
      ],
      showProgress: true,
      ongoing: true,
      autoCancel: false,
      progress: SongManager.nowProgress.inSeconds,
      maxProgress: SongManager.totalLength.inSeconds,
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      1,
      "正在播放",
      SongManager.musicItemInfo["name"] + ' - ' + SongManager.musicItemInfo["song"]["artists"]?[0]?["name"] ?? "未知歌手",
      notificationDetails,
    );
  }
}
