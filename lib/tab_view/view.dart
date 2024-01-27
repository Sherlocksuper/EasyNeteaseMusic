import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/view.dart';
import 'package:wyyapp/2find/view.dart';
import 'package:wyyapp/3roam/view.dart';
import 'package:wyyapp/5my/userpage.dart';
import 'package:wyyapp/KeepAliveWrapper.dart';
import 'package:wyyapp/LoginPrefs.dart';
import 'package:wyyapp/config.dart';
import 'package:wyyapp/login/view.dart';
import 'package:wyyapp/tab_view/drawer/view.dart';
import 'logic.dart';

class TabViewPage extends StatelessWidget {
  TabViewPage({Key? key}) : super(key: key);

  final logic = Get.put(TabViewLogic());
  final state = Get.find<TabViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async => {
          await LoginPrefs.init(),
          if (LoginPrefs.getCookie() == "null")
            {
              FlutterNativeSplash.remove(),
              Get.offAll(() => LoginPage()),
            },
          dio.options.headers["cookie"] = LoginPrefs.getCookie(),
          LoginPrefs.userInfo = await LoginPrefs.getMeInfo(),
          log(LoginPrefs.userInfo.toString()),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: TabViewContent(),
        );
      },
    );
  }
}

class TabViewContent extends StatelessWidget {
  TabViewContent({super.key});

  //find
  final logic = Get.find<TabViewLogic>();
  final state = Get.find<TabViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  TotalDrawer(),
      body: PageView(
        controller: state.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          logic.update();
        },
        children: [
          KeepAliveWrapper(child: CommendPage()),
          KeepAliveWrapper(child: FindPage()),
          KeepAliveWrapper(child: RoamPage()),
          // DynamicPage(),
          KeepAliveWrapper(child: UsePage(userId: LoginPrefs.getUserId(), type: 'user')),
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
              // BottomNavigationBarItem(
              //   //微信chat
              //   icon: Icon(Icons.chat_outlined),
              //   label: "动态",
              // ),
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
