import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/5my/state.dart';
import 'package:wyyapp/LoginPrefs.dart';
import 'package:wyyapp/utils/Notification.dart';
import '../config.dart';
import 'logic.dart';

Map userInfo = {};

class UsePage extends StatelessWidget {
  final logic = Get.put(MyLogic());
  final state = Get.find<MyLogic>().state;

  UsePage({super.key});

  @override
  Widget build(BuildContext context) {
    userInfo = LoginPrefs.userInfo;
    return Scaffold(
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
                  leading: GestureDetector(
                    onTap: () async {
                      // Scaffold.of(drawerContext).openDrawer();
                      await NotificationManager.displayNotification();
                    },
                    child: const Icon(
                      Icons.menu,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () async {
                        // await logic.logout();
                        // await logic.getCountInfo();
                      },
                      icon: const Icon(
                        Icons.search_outlined,
                      ),
                    ),
                  ],
                  pinned: true,
                  floating: false,
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
                SizedBox(
                  height: radius,
                  width: double.infinity,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: SizedBox(
                    height: radius * 3,
                    width: double.infinity,
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
                    onTap: () async {},
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
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
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
            itemCount: Get.find<MyLogic>().state.functionList.length,
            itemBuilder: (context, index) {
              FunctionItem item = Get.find<MyLogic>().state.functionList[index];
              return GestureDetector(
                onTap: () async {
                  item.onTap();
                },
                child: Column(
                  children: [
                    Icon(item.icon, size: 30, color: Colors.red),
                    const Gap(10),
                    AutoSizeText(
                      item.title,
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
