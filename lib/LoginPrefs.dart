import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPrefs {
  //user 0 , cookie null , role null
  static late SharedPreferences prefs;
  static late String cookie;
  static late int userId;
  static late String role; // user  visitor
  static late int createTime;

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
    return prefs.getInt("userId") ?? 0;
  }

  static int getCreateTime() {
    return prefs.getInt("createTime") ?? 0;
  }

  static Future<bool> setCreateTime(int createTime) async {
    return await prefs.setInt("createTime", createTime);
  }

  static Future<bool> setRole(String role) async {
    return await prefs.setString("role", role);
  }

  static String getRole() {
    return prefs.getString("role") ?? "null";
  }

  static AssetImage getAssetImages(String path) {
    return AssetImage("images/$path");
  }

  //传入一个map，将map中的数据存入本地
  static Future<void> setMap(Map<String, dynamic> map) async {
    setCookie(map["cookie"]);
    setUserId(map["userId"]);
    setRole(map["role"]);
    setCreateTime(map["createTime"]);
  }

  //清空本地数据
  static Future<void> clear() async {
    await prefs.clear();
  }
}
