import 'package:get/get.dart';

import '../config.dart';
import 'state.dart';

class FindLogic extends GetxController {
  final FindState state = FindState();

  //获取发现页功能列表
  Future getDragonBall() async {
    var res = await dio.get("$baseUrl/homepage/dragon/ball");
    state.functionList = res.data["data"];
    update();
  }
}

//{
//             "id": 1025001,
//             "name": "有声书",
//             "iconUrl": "http://p1.music.126.net/Kb4oK0m_ocs3FR3lo-r9yg==/109951167319110429.jpg",
//             "url": "orpheus://rnpage?component=rn-podcast-book&route=book-home&split=book-home&focusTab=book&mainProcessCompat=1",
//             "skinSupport": true,
//             "homepageMode": "RCMD_MODE",
//             "resourceState": null
//         },
