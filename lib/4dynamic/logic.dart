import 'package:get/get.dart';

import '../config.dart';
import 'state.dart';

class DynamicLogic extends GetxController {
  final DynamicState state = DynamicState();

  //获取动态
  Future<void> getDynamic() async {
    var response = await dio.get("$baseUrl/event");
    print(response);
  }
}
