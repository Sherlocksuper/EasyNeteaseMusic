import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'login/view.dart';

class LoginPrefs {
  //user 0 , cookie null , role null
  static late SharedPreferences prefs;
  static late String cookie;
  static late int userId;
  static late Map userInfo;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setCookie(String cookie) async {
    return await prefs.setString("cookie", cookie);
  }

  static String getCookie() {
    return prefs.getString("cookie") ?? "null";
  }

  static Future<bool> setUserId(int userId) async {
    return await prefs.setInt("userId", userId);
  }

  static int getUserId() {
    return prefs.getInt("userId") ?? 1897106867;
  }

  static AssetImage getAssetImages(String path) {
    return AssetImage("images/$path");
  }

  //传入一个map，将map中的数据存入本地
  static Future<void> setMap(Map<String, dynamic> map) async {
    //如果没有初始化，先初始化
    if (prefs == null) {
      await init();
    }

    setCookie(map["cookie"]);
    setUserId(map["userId"]);

    setUserId(1897106867);
  }

  //清空本地数据
  static Future<void> clear() async {
    await prefs.clear();
  }

  static Future<Map> getMeInfo() async {
    var response = await dio.get("$baseUrl/user/detail?uid=${LoginPrefs.getUserId()}");
    return response.data;
  }

  //退出登录
  static Future<void> logout() async {
    LoginPrefs.clear();
    Get.offAll(() => LoginPage());
  }

  static void showAppData() async {
    Get.defaultDialog(
      title: "AppData",
      content: const Text(
          //app制作者、联系方式、版本号、更新时间、更新内容
          "制作者：sherloc  lby\n"
          "联系方式：qq1785648438\n"),
    );
  }
}
