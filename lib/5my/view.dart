import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/config.dart';
import 'logic.dart';

class MyPage extends StatelessWidget {
  final logic = Get.put(MyLogic());
  final state = Get.find<MyLogic>().state;

  late BuildContext fatherContext;

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    fatherContext = context;
    return FutureBuilder(
      future: Future(
        () async => {
          await logic.getCountInfo(),
          // await logic.logout(),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          backgroundColor: defaultColor,
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScroll) {
              return <Widget>[
                SliverLayoutBuilder(
                  builder: (BuildContext context, constraints) {
                    return SliverAppBar(
                      toolbarHeight: 40,
                      stretch: true,
                      stretchTriggerOffset: 50,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        onPressed: () async {
                          Scaffold.of(fatherContext).openDrawer();
                        },
                        icon: const Icon(Icons.menu, color: Colors.black),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () async {
                            await logic.logout();
                            // await logic.getCountInfo();
                          },
                          icon: const Icon(
                            Icons.search_outlined,
                          ),
                        ),
                      ],
                      pinned: true,
                      floating: false,
                      iconTheme: const IconThemeData(
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ];
            },
            body: const SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(padding: EdgeInsets.only(top: 20, right: 20, left: 20), child: SelfPage()),
            ),
          ),
        );
      },
    );
  }
}

class SelfPage extends StatelessWidget {
  const SelfPage({super.key});

  final double radius = 40.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Column(
              children: [
                Container(
                  height: radius,
                  width: double.infinity,
                  color: Colors.transparent,
                ),
                Container(
                  height: radius * 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 10,
                  spacing: 10,
                  direction: Axis.vertical,
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: Get.find<MyLogic>().state.userInfo["profile"]["avatarUrl"],
                        width: radius * 2,
                        height: radius * 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.find<MyLogic>().logout();
                      },
                      child: Text(
                        Get.find<MyLogic>().state.userInfo["profile"]["nickname"],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "关注 ${Get.find<MyLogic>().state.userInfo["profile"]["follows"]}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Gap(10),
                        Text(
                          "粉丝 ${Get.find<MyLogic>().state.userInfo["profile"]["followeds"]}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Gap(10),
                        Text(
                          "等级 ${Get.find<MyLogic>().state.userInfo["level"]}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const Gap(20),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          width: Get.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: Get.find<MyLogic>().state.iconList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Icon(
                    Get.find<MyLogic>().state.iconList.values.toList()[index],
                    size: 30,
                    color: Colors.red,
                  ),
                  const Gap(10),
                  AutoSizeText(
                    Get.find<MyLogic>().state.iconList.keys.toList()[index],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class SelfPlayList extends StatelessWidget {
  const SelfPlayList({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          tabs: [],
        ),
      ),
    );
  }
}

class NoDataShowTile extends StatelessWidget {
  IconData icon;
  String title;
  String? subTitle;

  NoDataShowTile({super.key, required this.icon, required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(20),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.grey[400],
            ),
          ),
          const Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              Text(
                subTitle ?? "",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoDataShowShield extends StatelessWidget {
  const NoDataShowShield({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.vertical,
      children: [
        const Text(
          "登录后即可查看",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            //边缘
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: const Text(
            "立即登录",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
