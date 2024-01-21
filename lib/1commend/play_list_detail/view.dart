import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/5my/other_user_page/view.dart';
import 'logic.dart';

class PlayListDetailPage extends StatelessWidget {
  PlayListDetailPage({Key? key}) : super(key: key);

  final logic = Get.put(PlayListDetailLogic());
  final state = Get.find<PlayListDetailLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.getPlayDetail();
    return NestedScrollView(
      scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverLayoutBuilder(
            builder: (context, constraints) {
              final bool scrolled = constraints.scrollOffset > Get.height / 2 - 50;
              return SliverAppBar(
                toolbarHeight: 50,
                title: const Text(
                  '歌单',
                  style: TextStyle(color: Colors.white),
                ),
                pinned: true,
                //此处的距离计算可以推断出和上下两个bar的相隔距离，如果不需要可以直接设置为0
                expandedHeight: Get.height * 0.3 + 100,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'images/img.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Center(
                        child: GetBuilder<PlayListDetailLogic>(
                          builder: (controller) {
                            return PlayHeader();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.play_circle_fill_outlined,
                          color: Colors.red,
                        ),
                        const Gap(10),
                        const Text("播放全部"),
                        Text("(共${Get.find<PlayListDetailLogic>().state.playDetail["trackCount"]}首)",
                            style: const TextStyle(color: Colors.grey)),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.download_rounded),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ];
      },
      body: Container(
        width: Get.width,
        color: Colors.white,
        child: GetBuilder<PlayListDetailLogic>(
          builder: (controller) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: state.songlist.length,
              itemBuilder: (BuildContext context, int index) {
                return SongTile(songItem: state.songlist[index], index: index + 1);
              },
            );
          },
        ),
      ),
    );
  }
}

class PlayHeader extends StatelessWidget {
  const PlayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Get.find<PlayListDetailLogic>().state.playDetail["coverImgUrl"] == null
                    ? Image.asset(
                        'images/img.png',
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      )
                    : Image.network(
                        Get.find<PlayListDetailLogic>().state.playDetail["coverImgUrl"],
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      Get.find<PlayListDetailLogic>().state.playDetail["name"] ?? "默认名字",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Gap(10),
                    GestureDetector(
                      onTap: () {
                        Get.to(()=>OtherUserPagePage());
                      },
                      child: Row(
                        children: [
                          ClipOval(
                            child: Get.find<PlayListDetailLogic>().state.creator["avatarUrl"] == null
                                ? Image.asset(
                                    'images/img.png',
                                    fit: BoxFit.cover,
                                    width: 20,
                                    height: 20,
                                  )
                                : Image.network(
                                    Get.find<PlayListDetailLogic>().state.creator["avatarUrl"],
                                    fit: BoxFit.cover,
                                    width: 20,
                                    height: 20,
                                  ),
                          ),
                          const Gap(10),
                          Text(
                            Get.find<PlayListDetailLogic>().state.creator["nickname"] ?? "默认名字",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Flex(
                      direction: Axis.horizontal,
                      children: List.generate(
                        Get.find<PlayListDetailLogic>().state.playDetail["tags"].length,
                        (index) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(126, 148, 185, 0.4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            Get.find<PlayListDetailLogic>().state.playDetail["tags"][index] + ">",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const Gap(20),
          Text(
            Get.find<PlayListDetailLogic>().state.playDetail["description"] ?? "默认描述",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BuildIcon(
                  icon: Icons.share,
                  text: Get.find<PlayListDetailLogic>()
                      .changeNumber(Get.find<PlayListDetailLogic>().state.playDetail["shareCount"])),
              BuildIcon(
                  icon: Icons.comment_bank,
                  text: Get.find<PlayListDetailLogic>()
                      .changeNumber(Get.find<PlayListDetailLogic>().state.playDetail["commentCount"])),
              BuildIcon(
                  icon: Icons.add,
                  text: Get.find<PlayListDetailLogic>()
                      .changeNumber(Get.find<PlayListDetailLogic>().state.playDetail["subscribedCount"])),
            ],
          )
        ],
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  final Map songItem;
  final int index;

  const SongTile({super.key, required this.songItem, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$index", style: const TextStyle(color: Colors.grey)),
          const Gap(15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      songItem["name"] ?? "默认名字",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        songItem["alia"] == null || songItem["alia"].isEmpty ? "" : "(${songItem["alia"][0]})",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Text(
                    songItem["ar"][0]["name"] ?? "默认歌手" + " - ${songItem["al"]["name"] ?? "默认专辑"}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}

class BuildIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const BuildIcon({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (Get.width * 0.9 - 40) / 3,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(126, 148, 185, 0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const Gap(5),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
