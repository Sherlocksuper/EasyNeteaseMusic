import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'command_drawer/view.dart';
import 'logic.dart';

class CommendPage extends StatelessWidget {
  CommendPage({Key? key}) : super(key: key);

  final logic = Get.put(CommendLogic());
  final state = Get.find<CommendLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchBar(
          leading: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          trailing: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.qr_code_scanner_sharp,
                color: Colors.grey,
              ),
            ),
          ],
          hintText: "搜索",
          hintStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(const Color(0xffe9ecf1)),
          constraints: const BoxConstraints(
            minHeight: 40,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.mic_none,
              color: Colors.grey,
            ),
          ),
          const Gap(20),
        ],
      ),
      drawer: Drawer(
        width: Get.width * 0.8,
        backgroundColor: const Color(0xfff4f4f4),
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: SingleChildScrollView(
            child: CommandDrawer(),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {},
        child: const Center(
          child: Text("推荐"),
        ),
      ),
    );
  }
}

class CommandContent extends StatelessWidget {
  const CommandContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
