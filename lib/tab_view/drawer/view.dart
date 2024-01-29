import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/tab_view/drawer/state.dart';

import 'logic.dart';

class TotalDrawer extends Drawer {
  final logic = Get.put(CommandDrawerLogic());
  final state = Get.find<CommandDrawerLogic>().state;

  TotalDrawer({super.key});

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
                      "images/login.png",
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
                      style: TextStyle(fontSize: 18),
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
              EachTypeCard(title: "我的", type: FunctionType.me, children: state.functionList),
              // const Gap(10),
              // EachTypeCard(title: "音乐服务", type: FunctionType.service, children: state.functionList),
              const Gap(10),
              EachTypeCard(title: "其他", type: FunctionType.other, children: state.functionList),
              const Gap(10),
              EachTypeCard(title: "我的程序", type: FunctionType.myApp, children: state.functionList),
              const Gap(10),
            ],
          ),
        ),
      ),
    );
  }
}

class EachTypeCard extends StatelessWidget {
  final String title;
  final FunctionType type;
  final List<FunctionItem> children;

  const EachTypeCard({super.key, required this.title, required this.type, required this.children});

  @override
  Widget build(BuildContext context) {
    final source = children.where((element) => element.type == type).toList();

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            ListView.separated(
              //只返回和type相同的
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  log("message");
                  source[index].onTap();
                },
                child: Row(
                  children: [
                    Icon(source[index].icon),
                    const Gap(10),
                    Text(source[index].title),
                    const Spacer(),
                  ],
                ),
              ),
              itemCount: source.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey[200],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
