import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class DynamicPage extends StatelessWidget {
  DynamicPage({Key? key}) : super(key: key);

  final logic = Get.put(DynamicLogic());
  final state = Get.find<DynamicLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
