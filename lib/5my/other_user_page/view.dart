import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class OtherUserPagePage extends StatelessWidget {
  final int userId;

  OtherUserPagePage({Key? key, required this.userId}) : super(key: key);

  final logic = Get.put(OtherUserPageLogic());
  final state = Get.find<OtherUserPageLogic>().state;

  @override
  Widget build(BuildContext context) {
    state.userId = userId;
    return FutureBuilder(future: Future(() async {
      await logic.getOtherUserInfo();
      log(state.subCount.toString());
    }), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScroll) {
                return <Widget>[
                  SliverLayoutBuilder(
                    builder: (BuildContext context, constraints) {
                      final bool scrolled = constraints.scrollOffset > Get.height / 2 - 50;
                      return SliverAppBar(
                        stretch: true,
                        stretchTriggerOffset: 50,
                        backgroundColor: const Color(0xfff8f9fd),
                        actions: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_vert_sharp,
                            ),
                          ),
                        ],
                        expandedHeight: Get.height / 2,
                        pinned: true,
                        floating: false,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          centerTitle: true,
                          background: Stack(
                            alignment: Alignment.center,
                            children: [
                              GetBuilder<OtherUserPageLogic>(
                                builder: (logic) {
                                  return Image.network(
                                    Get.find<OtherUserPageLogic>().state.userInfo["backgroundUrl"] ?? "",
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    height: Get.height / 2 + 100,
                                  );
                                },
                              ),
                              Expanded(
                                child: Center(
                                  child: UserHeaderCard(),
                                ),
                              )
                            ],
                          ),
                        ),
                        iconTheme: IconThemeData(
                          color: scrolled ? Colors.black : const Color(0xfff8f9fd),
                        ),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(40),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xfff8f9fd),
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                            ),
                            child: const TabBar(
                              labelColor: Colors.black,
                              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black),
                              indicatorColor: Colors.red,
                              indicatorSize: TabBarIndicatorSize.label,
                              unselectedLabelColor: Colors.black,
                              unselectedLabelStyle: TextStyle(fontSize: 16, color: Colors.black),
                              tabs: [
                                Tab(
                                  text: "音乐",
                                ),
                                Tab(
                                  text: "动态",
                                ),
                                Tab(
                                  text: "播客",
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
              body: TabBarView(
                children: [
                  Container(
                    color: Colors.red,
                  ),
                  Container(
                    color: Colors.blue,
                  ),
                  Container(
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

class UserHeaderCard extends StatelessWidget {
  const UserHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherUserPageLogic>(
      builder: (controller) {
        return Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          spacing: 15,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Get.find<OtherUserPageLogic>().state.userInfo["avatarUrl"] == null
                  ? const Image(
                      image: AssetImage("images/img.png"),
                      width: 100,
                      height: 100,
                    )
                  : Image.network(
                      Get.find<OtherUserPageLogic>().state.userInfo["avatarUrl"],
                      width: 100,
                      height: 100,
                    ),
            ),
            Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 5,
              children: [
                Text(
                  Get.find<OtherUserPageLogic>().state.userInfo["nickname"] ?? "未知",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ],
            ),
            Wrap(
              spacing: 20,
              alignment: WrapAlignment.center,
              children: [
                buildNumberShow("关注", controller.state.userInfo["followeds"]),
                buildNumberShow("粉丝", controller.state.userInfo["follows"]),
                //等级
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.red,
                        size: 18,
                      ),
                      Text(
                        "Lv.${controller.state.totalInfo["level"]}",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Text(
                      "关注",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 75, 68),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "私信",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

Widget buildNumberShow(var title, var number) {
  return Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 5,
    direction: Axis.horizontal,
    children: [
      Text(
        number == null ? "0" : number.toString(),
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    ],
  );
}
