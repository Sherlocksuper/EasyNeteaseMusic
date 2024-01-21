import 'dart:developer';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/play_list_detail/view.dart';
import 'package:wyyapp/search/view.dart';
import '../config.dart';
import 'logic.dart';

class CommendPage extends StatelessWidget {
  CommendPage({Key? key}) : super(key: key);

  final logic = Get.put(CommendLogic());
  final state = Get.find<CommendLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Text("data"),
      appBar: AppBar(
        toolbarHeight: 40,
        title: Container(
          height: 30,
          decoration: BoxDecoration(
            color: defaultColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: "搜索歌曲、歌手、专辑",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.mic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20),
        child: CustomMaterialIndicator(
          child: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: CommandContent(),
          ),
          onRefresh: () async {
            await logic.toRefresh();
          },
          indicatorBuilder: (context, controller) {
            return const Icon(
              Icons.ac_unit,
              color: Colors.red,
              size: 30,
            );
          },
        ),
      ),
    );
  }
}

class CommandContent extends StatelessWidget {
  const CommandContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async => {
          await Get.find<CommendLogic>().init(),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Gap(10),
                Text(
                  //按照时间
                  DateTime.now().hour < 12
                      ? "早上好"
                      : DateTime.now().hour < 18
                          ? "下午好"
                          : "晚上好",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            //推荐歌单
            ShowShieldForCard(title: "推荐歌单", source: Get.find<CommendLogic>().state.commandPlayList),

            //热门榜单
            buildShowShield(
              SubTitle(
                title: "热门榜单",
                onTap: () {},
              ),
              SizedBox(
                height: 180,
                width: Get.width,
                child: GetBuilder<CommendLogic>(
                  builder: (controller) {
                    return PageView.builder(
                      controller: controller.state.pageController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return PageItem();
                      },
                      itemCount: 3,
                    );
                  },
                ),
              ),
            ),

            //排行榜
            ShowShieldForCard(title: "排行榜", source: Get.find<CommendLogic>().state.selectTopList),

            //热门榜单
            buildShowShield(
              SubTitle(
                title: "新人都在听",
                onTap: () {},
              ),
              SizedBox(
                height: 180,
                width: Get.width,
                child: GetBuilder<CommendLogic>(
                  builder: (controller) {
                    return PageView.builder(
                      controller: controller.state.pageController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return const PageItem();
                      },
                      itemCount: 3,
                    );
                  },
                ),
              ),
            ),

            ShowShieldForCard(title: "心情歌单", source: Get.find<CommendLogic>().state.moodPlayList),
            ShowShieldForCard(title: "场景歌单", source: Get.find<CommendLogic>().state.scenePlayList),
          ],
        );
      },
    );
  }
}

class ShowShieldForCard extends StatelessWidget {
  final String title;
  final Function? onTap;
  final List source;

  const ShowShieldForCard({super.key, required this.title, this.onTap, required this.source});

  @override
  Widget build(BuildContext context) {
    if (source.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: [
        const Gap(20),
        SubTitle(title: title, onTap: onTap),
        const Gap(15),
        SizedBox(
          height: 170,
          width: Get.width,
          child: ListView.separated(
            primary: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 10, right: 10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return PlaylistsCard(
                playItem: source[index],
              );
            },
            separatorBuilder: (context, index) {
              return const Gap(10);
            },
            itemCount: source.length,
          ),
        ),
        const Gap(10),
      ],
    );
  }
}

Widget buildShowShield(Widget title, Widget content) {
  return Column(
    children: [
      const Gap(20),
      title,
      const Gap(15),
      content,
      const Gap(10),
    ],
  );
}

class PageItem extends StatelessWidget {
  const PageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(Get.width * (-0.05) / 2, 0),
      child: SizedBox(
        width: Get.width,
        child: ListView.separated(
          itemCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return const SongTile();
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Gap(10);
          },
        ),
      ),
    );
  }
}

//这是歌单的卡片
class PlaylistsCard extends StatelessWidget {
  final Map playItem;

  const PlaylistsCard({super.key, required this.playItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(playItem);
        Get.to(() => PlayListDetailPage(), arguments: playItem);
      },
      child: SizedBox(
        width: 120,
        child: Column(
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    playItem["picUrl"] ?? playItem["coverImgUrl"],
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  ),
                ),
                const Positioned(
                  right: 5,
                  bottom: 5,
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 30),
                ),
              ],
            ),
            const Gap(10),
            Text(
              playItem["name"] ?? playItem["title"],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class DayCommandCard extends StatelessWidget {
  final Map dayCommandPlayItem;

  const DayCommandCard({super.key, required this.dayCommandPlayItem});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: 150,
        height: 180,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Image.asset(
              fit: BoxFit.cover,
              "images/test.png",
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 150,
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Text(
                  "离别开出花，我想念、浮光,01",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  const SongTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            fit: BoxFit.cover,
            "images/test.png",
            width: 50,
            height: 50,
          ),
        ),
        const Gap(10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "歌曲标题",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Gap(5),
              Text(
                "歌手名",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.play_arrow,
          color: Colors.grey,
        ),
        const Gap(10),
      ],
    );
  }
}

class SubTitle extends StatelessWidget {
  final String title;
  final Function? onTap;

  const SubTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Gap(10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            onTap!();
          },
          child: const Icon(
            //三个点
            Icons.more_vert_sharp,
            size: 16,
            color: Colors.grey,
          ),
        ),
        const Gap(10),
      ],
    );
  }
}
