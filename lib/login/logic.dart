import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import '../LoginPrefs.dart';
import '../config.dart';
import '../tab_view/view.dart';
import 'state.dart';
import 'package:flutter/material.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  Future<void> loginAsVisitor() async {
    var value = await dio.get("$baseUrl/register/anonimous");
    print(value);

    if (value.data["code"] == 200) {
      LoginPrefs.setMap(value.data);
      dio.options.headers["cookie"] = LoginPrefs.getCookie();
    } else {
      Get.defaultDialog(title: "错误", middleText: value.data["msg"]);
    }
  }

  // login/qr/key
  Future<void> getQrKey() async {
    var value = await dio.get("$baseUrl/login/qr/key?timestamp=${DateTime.now().millisecondsSinceEpoch}");
    log("获取二维码key");
    log(value.toString());
    if (value.data["code"] == 200) {
      state.qrKey = value.data["data"]["unikey"];
      await getQrImage();
      update();
    } else {
      Get.defaultDialog(title: "错误", middleText: value.data["msg"]);
    }
  }

  //login/qr/create?key=xxx
  Future<void> getQrImage() async {
    var value = await dio.get(
        "$baseUrl/login/qr/create?key=${state.qrKey}&qrimg=true&timestamp=${DateTime.now().millisecondsSinceEpoch}");
    log("获取二维码图片");
    log(value.toString());
    if (value.data["code"] == 200) {
      //利用base64解码，获取图片并弹出
      Get.defaultDialog(
        title: "扫码登录",
        content: Image.memory(
          base64Decode(value.data["data"]["qrimg"].split(",")[1]),
          width: 200,
          height: 200,
        ),
      );
      update();
    } else {
      Get.defaultDialog(title: "错误", middleText: value.data["msg"]);
    }
  }

  Future<void> getQrCode() async {
    var value =
        await dio.get("$baseUrl/login/qr/check?key=${state.qrKey}&timestamp=${DateTime.now().millisecondsSinceEpoch}");
    log("二维码登录");
    log(value.toString());
    if (value.data["code"] == 200) {
      update();
    } else {
      Get.defaultDialog(title: "错误", middleText: value.data["msg"]);
    }
  }
}
