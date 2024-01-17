import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class RoamPage extends StatelessWidget {
  RoamPage({Key? key}) : super(key: key);

  final logic = Get.put(RoamLogic());
  final state = Get.find<RoamLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("漫游"),
    );
  }
}
