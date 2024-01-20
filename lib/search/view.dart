import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final logic = Get.put(SearchLogic());
  final state = Get.find<SearchLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
