import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/view.dart';
import 'package:wyyapp/2find/view.dart';
import 'package:wyyapp/3roam/view.dart';
import 'package:wyyapp/4dynamic/view.dart';
import 'package:wyyapp/5my/view.dart';

import '../1commend/command_drawer/view.dart';
import 'logic.dart';

class TabViewPage extends StatelessWidget {
  TabViewPage({Key? key}) : super(key: key);

  final logic = Get.put(TabViewLogic());
  final state = Get.find<TabViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CommandDrawer(),
      body: PageView(
        controller: state.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          logic.update();
        },
        children: [
          CommendPage(),
          FindPage(),
          RoamPage(),
          DynamicPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: GetBuilder<TabViewLogic>(
        builder: (logic) {
          return BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              state.currentIndex = index;
              state.pageController.jumpToPage(index);
              logic.update();
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "推荐",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                label: "发现",
              ),
              BottomNavigationBarItem(
                //收音机
                icon: Icon(Icons.radio_outlined),
                label: "漫游",
              ),
              BottomNavigationBarItem(
                //微信chat
                icon: Icon(Icons.chat_outlined),
                label: "动态",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: "我的",
              ),
            ],
            selectedItemColor: Colors.red,
          );
        },
      ),
    );
  }
}
