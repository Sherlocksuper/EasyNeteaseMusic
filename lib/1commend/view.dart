import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/play_list_detail/view.dart' hide SongTile;
import 'package:wyyapp/search/result.dart';
import 'package:wyyapp/utils/Song.dart';
import '../config.dart';
import '../search/view.dart';
import 'logic.dart';

class CommendPage extends StatelessWidget {
  CommendPage({Key? key}) : super(key: key);

  final logic = Get.put(CommendLogic());
  final state = Get.find<CommendLogic>().state;

  @override
  Widget build(BuildContext context) {
    drawerContext = context;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(
            Icons.menu,
          ),
        ),
        title: GestureDetector(
          onTap: () {
            Get.to(() => SearchPage());
          },
          child: Container(
            height: 35,
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
      body: CustomMaterialIndicator(
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
          FlutterNativeSplash.remove(),
        },
      ),
      builder: (context, snapshot) {
        return GetBuilder<CommendLogic>(
          builder: (logic) {
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
                for (var item in Get.find<CommendLogic>().state.functionsMap.entries)
                  item.value.type == "card"
                      ? ShowShieldForCard(title: item.value.title, source: item.value.list)
                      : ShowShieldForSong(title: item.value.title, source: item.value.list)
              ],
            );
          },
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
            shrinkWrap: true,
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

//推荐音乐
class ShowShieldForSong extends StatelessWidget {
  final String title;
  final Function? onTap;
  final List source;

  const ShowShieldForSong({super.key, required this.title, this.onTap, required this.source});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(20),
        SubTitle(title: title, onTap: () {}),
        const Gap(15),
        SizedBox(
          height: 180,
          width: Get.width,
          child: GetBuilder<CommendLogic>(
            builder: (controller) {
              return PageView.builder(
                controller: controller.state.pageController,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, pageIndex) {
                  return Transform.translate(
                    offset: Offset(Get.width * (-0.05) / 2, 0),
                    child: SizedBox(
                      width: Get.width,
                      child: ListView.separated(
                        itemCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, itemIndex) {
                          var songItem = source[pageIndex * 3 + itemIndex];
                          return MusicItem(
                            title: songItem["name"] ?? songItem["title"],
                            subTitle: songItem["song"]["artists"][0]["name"] ?? songItem["artists"][0]["name"],
                            imageUrl: songItem["picUrl"] ?? songItem["album"]["picUrl"],
                            isRound: false,
                            onTapTile: () {
                              SongManager.playMusic(songItem);
                            },
                            tail: [
                              GestureDetector(
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Gap(10);
                        },
                      ),
                    ),
                  );
                },
                itemCount: 3,
              );
            },
          ),
        ),
      ],
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
        Get.to(
          () => PlayListDetailPage(
            playListId: playItem["id"],
          ),
        );
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
                  child: CachedNetworkImage(
                    imageUrl: playItem["picUrl"] ?? playItem["coverImgUrl"],
                    placeholder: (context, url) => Container(
                      color: Colors.grey,
                      width: 120,
                      height: 120,
                    ),
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
            Expanded(
              child: AutoSizeText(
                playItem["name"] ?? playItem["title"],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
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
      ],
    );
  }
}
