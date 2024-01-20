import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../logic.dart';

class CommandDrawer extends Drawer {
  CommandDrawer({super.key});

  final logic = Get.put(CommendLogic());
  final state = Get.find<CommendLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      "images/login.jpg",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "立即登录",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.qr_code_scanner_sharp,
                      color: Colors.grey,
                      size: 25,
                    ),
                  )
                ],
              ),
              const Gap(20),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    //渐变色
                    //#313231 #505156  #313231
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff313231),
                        Color(0xff505156),
                        Color(0xff313231),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "开通黑胶VIP",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Gap(15),
                          Text("立享超12万首无损音乐", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        child: const Text(
                          "会员中心",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Gap(10),
              buildDrawerContainer(
                [
                  buildDrawerTile("我的消息", () {}, Icons.email_outlined),
                  buildDrawerTile("会员中心", () {}, Icons.verified_user_outlined)
                ],
              ),
              const Gap(15),
              buildDrawerContainer(
                title: "音乐服务",
                [
                  buildDrawerTile("趣测", () {}, Icons.emoji_objects_outlined),
                  buildDrawerTile("云村有票", () {}, Icons.emoji_objects_outlined),
                  buildDrawerTile("商城", () {}, Icons.shopping_bag_outlined),
                  buildDrawerTile("Beat专区", () {}, Icons.music_note_outlined),
                  buildDrawerTile("音乐收藏家", () {}, Icons.music_note_outlined),
                  buildDrawerTile("视频彩铃", () {}, Icons.video_collection_outlined),
                ],
              ),
              const Gap(15),
              buildDrawerContainer(
                title: "其他",
                [
                  buildDrawerTile("设置", () {}, Icons.settings_outlined),
                  buildDrawerTile("深色模式", () {}, Icons.nights_stay_outlined),
                  buildDrawerTile("定时关闭", () {}, Icons.timer_outlined),
                  buildDrawerTile("个性装扮", () {}, Icons.emoji_objects_outlined),
                  buildDrawerTile("边听边存", () {}, Icons.download_outlined),
                  buildDrawerTile("在线听歌免流量", () {}, Icons.wifi_outlined),
                  buildDrawerTile("音乐黑名单", () {}, Icons.music_note_outlined),
                  buildDrawerTile("青少年模式", () {}, Icons.child_care_outlined),
                  buildDrawerTile("音乐闹钟", () {}, Icons.alarm_outlined),
                ],
              ),
              const Gap(15),
              buildDrawerContainer(
                title: "我的小程序",
                [
                  buildDrawerTile("我的小程序", () {}, Icons.apps_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildDrawerTile(String title, Function onTap, IconData iconData, {String? hintText}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: SizedBox(
      height: 30,
      child: Row(
        children: [
          Icon(iconData, color: Colors.black, size: 20),
          const Gap(10),
          Text(title, style: const TextStyle(fontSize: 18)),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios_sharp,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    ),
  );
}

Widget buildDrawerContainer(List<Widget> children, {String? title}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      children: [
        if (title != null)
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),

        //每个子项中间加一个分割线,最后一个不加
        ...List.generate(
          children.length,
          (index) {
            return Column(
              children: [
                const Divider(),
                children[index],
              ],
            );
          },
        ),
      ],
    ),
  );
}
