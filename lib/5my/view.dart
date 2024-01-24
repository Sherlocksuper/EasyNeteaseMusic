import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScroll) {
              return <Widget>[
                SliverLayoutBuilder(
                  builder: (BuildContext context, constraints) {
                    return SliverAppBar(
                      stretch: true,
                      stretchTriggerOffset: 50,
                      backgroundColor: const Color(0xfff8f9fd),
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
              child: SelfPage(),
            ),
          ),
        );
      },
    );
  }
}

class SelfPage extends StatelessWidget {
  const SelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
