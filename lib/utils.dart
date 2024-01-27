import 'dart:developer';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

void open(){
  EasyLoading.showToast("此功能暂未开放");
}