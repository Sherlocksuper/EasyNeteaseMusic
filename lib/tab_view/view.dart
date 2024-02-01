import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/view.dart';
import 'package:wyyapp/5my/userpage.dart';
import 'package:wyyapp/KeepAliveWrapper.dart';
import 'package:wyyapp/LoginPrefs.dart';
import 'package:wyyapp/config.dart';
import 'package:wyyapp/login/view.dart';
import 'package:wyyapp/music_play/logic.dart';
import 'package:wyyapp/tab_view/drawer/view.dart';
import 'package:wyyapp/utils/Song.dart';
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
          SongManager.initSongModule(),
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

class TabViewContent extends StatefulWidget {
  TabViewContent({super.key});

  @override
  State<TabViewContent> createState() => _TabViewContentState();
}

class _TabViewContentState extends State<TabViewContent> with TickerProviderStateMixin {
  //find
  final logic = Get.find<TabViewLogic>();

  final state = Get.find<TabViewLogic>().state;

  int currentIndex = 0;

  PlayerState playerState = PlayerState.stopped;

  @override
  Widget build(BuildContext context) {
    playerState = SongManager.playerState;

    return Scaffold(
      drawer: TotalDrawer(),
      body: PageView(
        controller: state.pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          logic.update();
        },
        children: [
          KeepAliveWrapper(child: CommendPage()),
          // KeepAliveWrapper(child: HomePage()),
          // KeepAliveWrapper(child: FindPage()),
          KeepAliveWrapper(child: UsePage()),
          // KeepAliveWrapper(child: RoamPage()),
          // DynamicPage(),
        ],
      ),
      bottomNavigationBar: GetBuilder<TabViewLogic>(
        builder: (logic) {
          return BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              currentIndex = index;
              state.pageController.jumpToPage(index);
              logic.update();
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "推荐",
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.explore_outlined),
              //   label: "哈哈",
              // ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.explore_outlined),
              //   label: "发现",
              // ),
              // BottomNavigationBarItem(
              //   收音机
              // icon: Icon(Icons.radio_outlined),
              // label: "漫游",
              // ),
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
      // bottomSheet: GetBuilder<MusicPlayLogic>(
      //   builder: (logic) {
      //     if (SongManager.musicItemInfo.isEmpty) {
      //       return const SizedBox();
      //     }
      //     return GestureDetector(
      //       onTap: () {
      //         SongManager.playMusic(SongManager.musicItemInfo);
      //       },
      //       child: Container(
      //         height: 80,
      //         color: Colors.white,
      //         padding: const EdgeInsets.all(15),
      //         child: Row(
      //           children: [
      //             RotationTransition(
      //               turns: Tween(begin: 0.0, end: 1.0).animate(
      //                 AnimationController(
      //                   vsync: this,
      //                   duration: const Duration(seconds: 10),
      //                 )..repeat(),
      //               ),
      //               child: ClipOval(
      //                 child: CachedNetworkImage(
      //                   imageUrl: SongManager.musicItemInfo["picUrl"] ?? "",
      //                 ),
      //               ),
      //             ),
      //             const Gap(10),
      //             Column(
      //               children: [
      //                 Text(SongManager.musicItemInfo["name"],
      //                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      //                 Text(SongManager.musicItemInfo["song"]?["artists"]?[0]?["name"] ?? ""),
      //               ],
      //             ),
      //             const Spacer(),
      //             IconButton(
      //               onPressed: () {
      //                 if (SongManager.playerState == PlayerState.playing) {
      //                   SongManager.pauseMusic();
      //                 } else {
      //                   SongManager.continueMusic();
      //                 }
      //               },
      //               //根据播放状态
      //               icon: Icon(
      //                 SongManager.playerState == PlayerState.playing ? Icons.pause : Icons.play_arrow,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
