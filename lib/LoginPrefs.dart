import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPrefs {
  static late SharedPreferences prefs;
  static late String cookie;
  static late int userId;
  static late String role;  // user  visitor

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

  static Future<bool> setRole(String role) async {
    return await prefs.setString("role", role);
  }

  static String getRole() {
    return prefs.getString("role") ?? "null";
  }

  static AssetImage getAssetImages(String path) {
    return AssetImage("images/$path");
  }
}
