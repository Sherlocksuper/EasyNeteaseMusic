import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/play_list_detail/view.dart';
import 'package:wyyapp/KeepAliveWrapper.dart';
import '../config.dart';
import 'logic.dart';

class PlaylistSquarePage extends StatelessWidget {
  PlaylistSquarePage({Key? key}) : super(key: key);

  final logic = Get.put(PlaylistSquareLogic());
  final state = Get.find<PlaylistSquareLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xfff8f9fd),
      child: DefaultTabController(
        length: state.myPlayListTags.length,
        child: Scaffold(
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              ...List.generate(
                state.myPlayListTags.length,
                (index) => KeepAliveWrapper(
                  child: PlaylistPage(
                    tag: state.myPlayListTags[index],
                  ),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            title: const Text("歌单广场"),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.transparent,
                      tabs: [
                        ...List.generate(
                          state.myPlayListTags.length,
                          (index) => Tab(
                            text: state.myPlayListTags[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(() => const PlaylistTagsPage());
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//单个的tag独立的page，传入一个tag当参数
class PlaylistPage extends StatelessWidget {
  final String tag;

  PlaylistPage({super.key, required this.tag});

  final logic = Get.find<PlaylistSquareLogic>();
  List playList = [];
  int offset = 0;

  ScrollController scontroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async => {
          await logic.getPlayListCatList(),
          playList = await logic.getHighqualityPlayListTags(tag, offset),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_circle_fill_outlined, color: Colors.red),
              Text("加载中"),
            ],
          );
        }
        return GetBuilder<PlaylistSquareLogic>(
          id: "playList$tag",
          builder: (logic) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              controller: scontroller
                ..addListener(
                  () async {
                    if (scontroller.position.pixels == scontroller.position.maxScrollExtent) {
                      EasyLoading.showToast("加载中");
                      offset++;
                      playList.addAll(await logic.getHighqualityPlayListTags(tag, offset));
                      logic.update(["playList$tag"]);
                    }
                  },
                ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.8, crossAxisSpacing: 10, mainAxisSpacing: 15),
              padding: const EdgeInsets.all(10),
              itemCount: playList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => PlayListDetailPage(playListId: playList[index]["id"]));
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: playList[index]["coverImgUrl"],
                          placeholder: (context, url) => const Icon(Icons.music_note),
                          placeholderFadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                          width: (Get.width - 40) / 3,
                          height: (Get.width - 40) / 3,
                        ),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          playList[index]["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

//tags集合的page，在这里选择
class PlaylistTagsPage extends StatelessWidget {
  const PlaylistTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: const Text("歌单分类"),
      ),
      body: Container(
        color: Colors.white,
        width: Get.width,
        height: Get.height,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GetBuilder<PlaylistSquareLogic>(
            builder: (logic) {
              return Column(
                children: [
                  BuildTagField(cat: "语种", tags: Get.find<PlaylistSquareLogic>().state.langPlayListTags),
                  const Gap(20),
                  BuildTagField(cat: "风格", tags: Get.find<PlaylistSquareLogic>().state.stylePlayListTags),
                  const Gap(20),
                  BuildTagField(cat: "场景", tags: Get.find<PlaylistSquareLogic>().state.scenePlayListTags),
                  const Gap(20),
                  BuildTagField(cat: "情感", tags: Get.find<PlaylistSquareLogic>().state.moodPlayListTags),
                  const Gap(20),
                  BuildTagField(cat: "主题", tags: Get.find<PlaylistSquareLogic>().state.themePlayListTags),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

//主题和主题对应的标签,传入一个tags和cat的list
class BuildTagField extends StatelessWidget {
  final String cat;
  final List tags;

  const BuildTagField({super.key, required this.cat, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        Text(cat),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 2.8, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: tags.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 50,
                      title: Text(tags[index]["name"]),
                    ),
                    body: PlaylistPage(tag: tags[index]["name"]),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xfff3f3f3),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (tags[index]["hot"] == true)
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "热",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    AutoSizeText(
                      tags[index]["name"],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
