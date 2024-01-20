import 'package:get/get.dart';
import '../LoginPrefs.dart';
import '../config.dart';
import 'state.dart';

class MyLogic extends GetxController {
  final MyState state = MyState();


  Future<void> getUserDetail() async {
    var response = await dio.get("$baseUrl/user/detail?uid=${LoginPrefs.getUserId()}");
    print(response);
  }

}
