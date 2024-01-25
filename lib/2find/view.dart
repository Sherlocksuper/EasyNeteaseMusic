import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import 'logic.dart';

class FindPage extends StatelessWidget {
  FindPage({Key? key}) : super(key: key);

  final logic = Get.put(FindLogic());
  final state = Get.find<FindLogic>().state;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          leading: IconButton(
            onPressed: () async {
              Scaffold.of(drawerContext).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          title: const Text("发现"),
          actions: [
            IconButton(
              onPressed: () {
                log("点击了搜索");
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }
}
