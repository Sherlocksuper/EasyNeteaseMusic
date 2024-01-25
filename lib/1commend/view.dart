import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/play_list_detail/view.dart' hide SongTile;
import 'package:wyyapp/Song.dart';
import 'package:wyyapp/utils.dart';
import '../config.dart';
import '../music_play/view.dart';
import 'logic.dart';

class CommendPage extends StatelessWidget {
  CommendPage({Key? key}) : super(key: key);

  final logic = Get.put(CommendLogic());
  final state = Get.find<CommendLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        title: Container(
          height: 40,
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
        padding: const EdgeInsets.only(top: 10),
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
          FlutterNativeSplash.remove(),
        },
      ),
      builder: (context, snapshot) {
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
            ShowShieldForCard(title: "推荐歌单", source: Get.find<CommendLogic>().state.commandPlayList),
            ShowShieldForSong(title: "新歌推荐", source: Get.find<CommendLogic>().state.newSongList),
            ShowShieldForCard(title: "排行榜", source: Get.find<CommendLogic>().state.selectTopList),
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
    return GetBuilder<CommendLogic>(
      builder: (logic) {
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
      },
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
                          return SongTile(songItem: source[pageIndex * 3 + itemIndex + 1]);
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

class SongTile extends StatelessWidget {
  final Map songItem;

  const SongTile({super.key, required this.songItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SongManager.playMusic(songItem);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: songItem["picUrl"] ?? songItem["album"]["picUrl"],
              fit: BoxFit.cover,
              width: 50,
              height: 50,
              fadeInDuration: const Duration(milliseconds: 100),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songItem["name"] ?? songItem["title"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(5),
                Text(
                  songItem["song"]["artists"][0]["name"] ?? songItem["artists"][0]["name"],
                  style: const TextStyle(
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
