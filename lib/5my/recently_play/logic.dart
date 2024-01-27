import 'package:get/get.dart';

import '../../config.dart';
import 'state.dart';

class RecentlyPlayLogic extends GetxController {
  final RecentlyPlayState state = RecentlyPlayState();
  int limit = 30;

  //获取最近播放
  Future getRecentlyPlay(String type) async {
    var recentlyPlay = await dio.get("$baseUrl/record/recent/$type?limit=$limit");
    return recentlyPlay.data["data"];
  }
}
