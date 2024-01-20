import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/search/view.dart';
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
        leading: GestureDetector(
          onTap: () async {
            Scaffold.of(context).openDrawer();
            // await logic.getCommandPlayList();
            // await logic.toRefresh();
            // await logic.init();
          },
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        title: SearchBar(
          leading: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          trailing: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.qr_code_scanner_sharp,
                color: Colors.grey,
              ),
            ),
          ],
          hintText: "搜索",
          hintStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          onTap: () {
            Get.to(() => SearchPage());
          },
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(const Color(0xffe9ecf1)),
          constraints: const BoxConstraints(
            minHeight: 35,
            maxHeight: 35,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.mic_none,
              color: Colors.grey,
            ),
          ),
          const Gap(20),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 20),
        child: CustomMaterialIndicator(
          child: const SingleChildScrollView(
            physics:BouncingScrollPhysics(),
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
        buildShowShield(
          SubTitle(
            title: "推荐歌单",
            onTap: () {},
          ),
          GetBuilder<CommendLogic>(
            builder: (controller) {
              return SizedBox(
                height: 170,
                width: Get.width,
                child: ListView.separated(
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return PlaylistsCard(
                      playItem: Get.find<CommendLogic>().state.commandPlayList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(10);
                  },
                  itemCount: Get.find<CommendLogic>().state.commandPlayList.length,
                ),
              );
            },
          ),
        ),

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
        buildShowShield(
          SubTitle(
            title: "排行榜",
            onTap: () {},
          ),
          SizedBox(
            height: 180,
            width: Get.width,
            child: GetBuilder<CommendLogic>(
              builder: (controller) {
                //从topList中随机选取六个组成新的list
                return ListView.separated(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  physics: const RangeMaintainingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TopCard(topItem: controller.state.selectTopList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(10);
                  },
                  itemCount: controller.state.selectTopList.length,
                );
              },
            ),
          ),
        ),
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
                    return PageItem();
                  },
                  itemCount: 3,
                );
              },
            ),
          ),
        ),
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
      onTap: () {},
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
                    playItem["picUrl"],
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
              playItem["name"],
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

//这是排行榜的卡片
class TopCard extends StatelessWidget {
  final Map topItem;

  const TopCard({super.key, required this.topItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                    topItem["coverImgUrl"],
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
              topItem["description"] ?? topItem["name"],
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
