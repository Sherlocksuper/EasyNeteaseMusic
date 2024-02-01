import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/config.dart';
import 'logic.dart';

double headerHeight = 50;

class DynamicPage extends StatelessWidget {
  DynamicPage({Key? key}) : super(key: key);

  final logic = Get.put(DynamicLogic());
  final state = Get.find<DynamicLogic>().state;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: defaultColor,
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 40,
          backgroundColor: defaultColor,
          leading: GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
          title: const PreferredSize(
            preferredSize: Size.fromWidth(50),
            child: TabBar(
              indicatorColor: Colors.red,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              indicatorWeight: 3,
              padding: EdgeInsets.all(70),
              tabs: [
                Text("关注"),
                Text("广场"),
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                logic.getDynamic();
              },
              child: const Icon(
                Icons.add_circle,
                color: Colors.red,
                size: 30,
              ),
            ),
            const Gap(20),
          ],
        ),
        body: TabBarView(
          children: [
            Center(child: ListView.builder(itemBuilder: (context, index) => _cell(), itemCount: 10)),
            Center(child: ListView.builder(itemBuilder: (context, index) => _cell(), itemCount: 10)),
          ],
        ),
      ),
    );
  }
}

Widget _cell() {
  return Container(
    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.grey,
        ),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.asset(
            'images/analyze.png',
            width: headerHeight,
            height: headerHeight,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: headerHeight,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "名称",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 15, 10),
                child: const Text(
                  "网恋半年，女友突然说要分手，我问为什么，她说：我爸妈说我还小，不能谈恋爱，"
                  "我说：那你爸妈怎么知道我们在谈恋爱，她说：我爸妈说我还小，不能谈恋爱，"
                  "我说：那你爸妈怎么知道我们在谈恋爱,我说：那你爸妈怎么知道我们在谈恋爱"
                  "我说：那你爸妈怎么知道我们在谈恋爱,我说：那你爸妈怎么知道我们在谈恋爱",
                  style: TextStyle(fontSize: 15),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Row(
                children: [
                  Icon(
                    Icons.thumb_up,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Gap(5),
                  Text(
                    "点赞",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Gap(20),
                  Icon(
                    Icons.comment,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Gap(5),
                  Text(
                    "评论",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Gap(20),
                  Icon(
                    Icons.share,
                    color: Colors.grey,
                    size: 20,
                  ),
                  Gap(5),
                  Text(
                    "分享",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.more_vert_sharp,
                    color: Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
