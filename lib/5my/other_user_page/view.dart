import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'logic.dart';

class OtherUserPagePage extends StatelessWidget {
  OtherUserPagePage({Key? key}) : super(key: key);

  final logic = Get.put(OtherUserPageLogic());
  final state = Get.find<OtherUserPageLogic>().state;

  @override
  Widget build(BuildContext context) {
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
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    fit: BoxFit.cover,
                                    "images/test.png",
                                    width: 100,
                                    height: 100,
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
          body: TabBarView(
            children: [],
          ),
        ),
      ),
    );
  }
}
