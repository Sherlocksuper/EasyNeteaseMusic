import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/tab_view/logic.dart';
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
          onTap: () {
            Scaffold.of(context).openDrawer();
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
        child: const SingleChildScrollView(
          child: CommandContent(),
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
          SizedBox(
            height: 170,
            width: Get.width,
            child: ListView.separated(
                padding: const EdgeInsets.only(left: 10, right: 10),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 120,
                    child: PlaylistsCard(
                      title: "歌歌单标题歌单标题歌单标题歌单标题歌单标题单标题a",
                      url: "images/test.png",
                      onTap: () {},
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Gap(10);
                },
                itemCount: 10),
          ),
        ),
        buildShowShield(
          SubTitle(
            title: "每日推荐",
            onTap: () {},
          ),
          SizedBox(
            height: 180,
            width: Get.width,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 10, right: 10),
                itemBuilder: (context, item) {
                  return DayCommandCard(
                    title: "歌歌单标题歌单标题歌单标题歌单标题歌单标题单标题a",
                    url: "images/test.png",
                    onTap: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return const Gap(10);
                },
                itemCount: 10),
          ),
        ),
        buildShowShield(
          SubTitle(
            title: "推荐歌曲",
            onTap: () {},
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            height: 180,
            width: Get.width,
            child: PageView.builder(
              itemCount: 3,
              controller: Get.find<CommendLogic>().state.pageController,
              itemBuilder: (context, index) {
                return const PageItem();
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
      offset: Offset(Get.width * (-0.05), 0),
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

class PlaylistsCard extends StatelessWidget {
  final String title;
  final Function onTap;
  final String url;

  const PlaylistsCard({super.key, required this.title, required this.onTap, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(
                  fit: BoxFit.cover,
                  url,
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
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class DayCommandCard extends StatelessWidget {
  final String title;
  final Function onTap;
  final String url;

  const DayCommandCard({super.key, required this.title, required this.onTap, required this.url});

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
        Image.asset(
          fit: BoxFit.cover,
          "images/test.png",
          width: 50,
          height: 50,
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
