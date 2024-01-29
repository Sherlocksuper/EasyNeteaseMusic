import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wyyapp/KeepAliveWrapper.dart';
import 'package:wyyapp/search/result.dart';
import 'package:wyyapp/utils/Song.dart';

import 'logic.dart';

class RecentlyPlayPage extends StatelessWidget {
  RecentlyPlayPage({Key? key}) : super(key: key);

  final logic = Get.put(RecentlyPlayLogic());
  final state = Get.find<RecentlyPlayLogic>().state;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: state.typeList.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("最近播放"),
          bottom: TabBar(
            tabs: state.typeList.map((e) => Tab(text: e.name)).toList(),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.red,
            labelColor: Colors.red,
          ),
        ),
        body: TabBarView(
          children: state.typeList.map((e) => KeepAliveWrapper(child: BasePage(type: e.type))).toList(),
        ),
      ),
    );
  }
}

class BasePage extends StatelessWidget {
  final String type;
  late final Map data;

  // ignore: prefer_const_constructors_in_immutables
  BasePage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async => {
          data = await Get.find<RecentlyPlayLogic>().getRecentlyPlay(type),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            //正在加载
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.only(left: 20, top: 10),
          itemCount: data["list"].length,
          itemBuilder: (context, index) {
            Map item = data["list"][index];
            return MusicItem(
              title: item["song"]?["name"] ?? item["data"]?["name"] ?? "未知",
              subTitle: item["song"]?["ar"]?[0]?["name"] ?? item["data"]?["ar"]?[0]?["name"] ?? "未知",
              tail: [
                IconButton(
                  onPressed: () async {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
              onTapTile: () async {
                SongManager.playMusic(item["data"]);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        );
      },
    );
  }
}
