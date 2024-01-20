import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PlayListDetailPage extends StatelessWidget {
  PlayListDetailPage({Key? key}) : super(key: key);

  final logic = Get.put(PlayListDetailLogic());
  final state = Get.find<PlayListDetailLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
