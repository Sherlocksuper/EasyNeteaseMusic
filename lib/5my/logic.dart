import 'dart:developer';

import 'package:get/get.dart';
import '../LoginPrefs.dart';
import '../config.dart';
import '../login/view.dart';
import 'state.dart';

class MyLogic extends GetxController {
  final MyState state = MyState();

  //getCountInfo
  Future<void> getCountInfo() async {
    print(LoginPrefs.getUserId());
    var response = await dio.get("$baseUrl/user/detail?uid=${LoginPrefs.getUserId()}");
    state.userInfo = response.data;
    log(response.toString());
  }

  //退出登录
  Future<void> logout() async {
    LoginPrefs.clear();
    Get.offAll(() => LoginPage());
  }
}
