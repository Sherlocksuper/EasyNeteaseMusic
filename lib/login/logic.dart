import 'package:get/get.dart';

import '../LoginPrefs.dart';
import '../config.dart';
import '../tab_view/view.dart';
import 'state.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();

  Future<void> loginAsVisitor() async {
    var value = await dio.get("$baseUrl/register/anonimous");
    if (value.data["code"] == 200) {
      LoginPrefs.setCookie(value.data["cookie"]);
      LoginPrefs.setUserId(value.data["userId"]);

      dio.options.headers["cookie"] = LoginPrefs.getCookie();
      Get.off(() => TabViewPage());
    } else {
      Get.defaultDialog(title: "错误", middleText: value.data["msg"]);
    }
  }
}
