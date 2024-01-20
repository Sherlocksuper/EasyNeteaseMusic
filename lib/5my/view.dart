import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/1commend/command_drawer/view.dart';
import 'logic.dart';

class MyPage extends StatelessWidget {
  final logic = Get.put(MyLogic());
  final state = Get.find<MyLogic>().state;

  late BuildContext fatherContext;

  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    fatherContext = context;
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
                    backgroundColor: const Color(0xfff8f9fd)
                    ,
                    leading: IconButton(
                      onPressed: () async {
                        // Scaffold.of(fatherContext).openDrawer();
                        Dio dio = new Dio();

                        var response = await dio.get("http://http://172.27.128.1:3000/search?keywords=%E6%B5%B7%E9%98%94%E5%A4%A9%E7%A9%BA");
                        Get.defaultDialog(
                          title: "提示",
                          content: Text(response.toString()),
                          textConfirm: "确定",
                          onConfirm: () {
                            Get.back();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.menu,
                        color: scrolled ? Colors.black : const Color(0xfff8f9fd),
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search_outlined,
                        ),
                      ),
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
                      centerTitle: true,
                      background: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              fit: BoxFit.cover,
                              "images/img.png",
                              width: Get.width,
                              height: Get.height / 2 + 100,
                            ),
                            Column(
                              children: [
                                Gap(Get.height / 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    fit: BoxFit.cover,
                                    "images/test.png",
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                const Gap(20),
                                const Text(
                                  "立即登录  >",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    iconTheme: IconThemeData(
                      color: scrolled ? Colors.black : const Color(0xfff8f9fd),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(40),
                      child: Container(
                        decoration: const BoxDecoration(
                          //248, 249, 253
                          color: Color(0xfff8f9fd),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
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
                              text: "播客",
                            ),
                            Tab(
                              text: "动态",
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
          body: const TabBarView(
            children: [
              Music(),
              Podcasts(),
              Dynamic(),
            ],
          ),
        ),
      ),
    );
  }
}

class Music extends StatelessWidget {
  const Music({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TabBar(
                labelColor: Colors.black,
                indicatorWeight: 0.1,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                isScrollable: true,
                tabs: [
                  Tab(
                    text: "单曲",
                  ),
                  Tab(
                    text: "歌单",
                  ),
                ],
                //尾部
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.sort,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert_sharp,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                NoDataShowTile(
                  //心脏图标
                  icon: Icons.favorite,
                  title: "我喜欢的音乐",
                  subTitle: "快去发现喜欢的音乐吧",
                ),
                NoDataShowTile(
                  icon: Icons.add,
                  title: "暂无数据",
                  subTitle: "快去发现喜欢的音乐吧",
                ),
                NoDataShowTile(
                  icon: Icons.file_download,
                  title: "暂无数据",
                  subTitle: "快去发现喜欢的音乐吧",
                ),
              ],
            ),
            Column(
              children: [
                NoDataShowTile(
                  //心脏图标
                  icon: Icons.favorite,
                  title: "我喜欢的音乐",
                  subTitle: "快去发现喜欢的音乐吧",
                ),
                NoDataShowTile(
                  icon: Icons.add,
                  title: "暂无数据",
                  subTitle: "快去发现喜欢的音乐吧",
                ),
                NoDataShowTile(
                  icon: Icons.file_download,
                  title: "暂无数据",
                  subTitle: "快去发现喜欢的音乐吧",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Podcasts extends StatelessWidget {
  const Podcasts({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TabBar(
                labelColor: Colors.black,
                indicatorWeight: 0.1,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black),
                isScrollable: true,
                tabs: [
                  Tab(
                    text: "全部",
                  ),
                  Tab(
                    text: "播客",
                  ),
                  Tab(
                    text: "有声书",
                  ),
                ],
                //尾部
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.sort,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert_sharp,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                NoDataShowTile(
                  icon: Icons.add,
                  title: "添加播客和有声书",
                ),
              ],
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "暂无数据",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "暂无数据",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Dynamic extends StatelessWidget {
  const Dynamic({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: NoDataShowShield(),
    );
  }
}

//前去添加之类的
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
