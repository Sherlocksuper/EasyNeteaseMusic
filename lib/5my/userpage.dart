import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/5my/download/view.dart';
import 'package:wyyapp/utils/Song.dart';
import 'package:wyyapp/config.dart';
import 'logic.dart';

Map userInfo = {};

class UsePage extends StatelessWidget {
  final logic = Get.put(MyLogic());
  final state = Get.find<MyLogic>().state;

  final int userId;
  final String type;

  UsePage({
    super.key,
    required this.userId,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async => {
          userInfo = await logic.getUserDetail(userId),
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
                          Scaffold.of(drawerContext).openDrawer();
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
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                spacing: 10,
                direction: Axis.vertical,
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userInfo["profile"]["avatarUrl"],
                      width: radius * 2,
                      height: radius * 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                    },
                    child: Text(
                      userInfo["profile"]["nickname"],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "关注 ${userInfo["profile"]["follows"]}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Gap(10),
                      Text(
                        "粉丝 ${userInfo["profile"]["followeds"]}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Gap(10),
                      Text(
                        "等级 ${userInfo["level"]}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
              return GestureDetector(
                onTap: () async {
                  Get.to(()=>DownloadPage());
                },
                child: Column(
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
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
