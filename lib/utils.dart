import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'LoginPrefs.dart';
import 'config.dart';
import 'music_play/logic.dart';
import 'music_play/view.dart';

//改变数字显示
String changeNumber(int number) {
  if (number > 10000) {
    return "${(number / 10000).toStringAsFixed(1)}万";
  } else {
    return number.toString();
  }
}

//下载文件
Future<bool> downLoadImage(String url) async {
  if (await Permission.storage.request().isGranted) {
    var response = await dio.get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    if (result["isSuccess"] == true) {
      EasyLoading.showToast("下载成功");
      return true;
    } else {
      EasyLoading.showToast("下载失败,请重试");
      return false;
    }
  } else {
    EasyLoading.showToast("暂无权限");
    return false;
  }
}

Future<void> open() async {
  var methodChannel = MethodChannel("test");
  var test = await methodChannel.invokeMethod("moveback");
  log(test.toString());
  // EasyLoading.showToast("此功能暂未开放");
}

Future<void> moveback() async {
  var methodChannel = const MethodChannel("test");
  var test = await methodChannel.invokeMethod("moveTaskToBack");
  log(test.toString());
}

//防抖
Function debounce(Function fn, [int t = 300]) {
  var delay = t;
  Timer? timer;
  return () {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: delay), () => fn());
  };
}

//节流
Function throttle(Function fn, [int t = 300]) {
  var lastTime = DateTime.now().millisecondsSinceEpoch;
  return () {
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    if (nowTime - lastTime > t) {
      fn();
      lastTime = nowTime;
    }
  };
}
