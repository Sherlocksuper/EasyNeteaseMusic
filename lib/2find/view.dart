import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class FindPage extends StatelessWidget {
  FindPage({Key? key}) : super(key: key);

  final logic = Get.put(FindLogic());
  final state = Get.find<FindLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("发现"),
    );
  }
}
