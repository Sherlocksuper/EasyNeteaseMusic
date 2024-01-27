import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/config.dart';
import 'logic.dart';

Map userInfo = {};

class ArtistPage extends StatelessWidget {
  final logic = Get.put(MyLogic());
  final state = Get.find<MyLogic>().state;

  final int userId;

  ArtistPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async => {
          userInfo = await logic.getArtistDetail(userId),
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
          body: Stack(
            children: [
              Positioned(
                top: 0,
                child: CachedNetworkImage(
                  imageUrl: userInfo["profile"]?["backgroundUrl"] ?? userInfo["user"]?["backgroundUrl"],
                  height: Get.height * 0.4,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),
              ),
              NestedScrollView(
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
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child:
                      Padding(padding: EdgeInsets.only(top: Get.height * 0.2, right: 20, left: 20), child: SelfPage()),
                ),
              ),
            ],
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
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
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
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 10,
            spacing: 10,
            direction: Axis.vertical,
            children: [
              Positioned(
                top: radius,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: userInfo["profile"]?["avatarUrl"] ?? userInfo["user"]?["avatarUrl"],
                    width: radius * 2,
                    height: radius * 2,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Get.find<MyLogic>().logout();
                },
                child: Text(
                  userInfo["profile"]?["nickname"] ?? userInfo["user"]?["nickname"],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "关注 ${userInfo["profile"]?["follows"] ?? userInfo["user"]?["follows"] ?? 0}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Gap(10),
                  Text(
                    "粉丝 ${userInfo["profile"]?["followeds"] ?? userInfo["user"]?["followeds"] ?? 0}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Gap(10),
                  Text(
                    "动态 ${userInfo["profile"]?["eventCount"] ?? userInfo["user"]?["eventCount"] ?? 0}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Text(
                userInfo["artist"]?["indentifyTag"]?.join("/") ?? "普通人",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Gap(20),
      ],
    );
  }
}
