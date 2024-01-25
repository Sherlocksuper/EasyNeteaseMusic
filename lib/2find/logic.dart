import 'package:get/get.dart';
import 'package:wyyapp/LoginPrefs.dart';

import '../config.dart';
import '../login/view.dart';
import 'state.dart';

class FindLogic extends GetxController {
  final FindState state = FindState();

  //https://music.163.com/song?id=29436904
  Future getBanner() async {
    LoginPrefs.clear();
    Get.offAll(() => LoginPage());
  }
}
