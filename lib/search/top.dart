import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wyyapp/search/result.dart';

import 'logic.dart';

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildIconWithTitle(Icons.person, "歌手"),
                const MVerticalDivider(),
                buildIconWithTitle(Icons.music_note, "曲风"),
                const MVerticalDivider(),
                buildIconWithTitle(Icons.album, "专区"),
                const MVerticalDivider(),
                buildIconWithTitle(Icons.mic, "识曲"),
              ],
            ),
          ),
        ),
        const SliverGap(10),
        SliverToBoxAdapter(
          child: Container(
            height: 820,
            width: Get.width,
            margin: const EdgeInsets.only(bottom: 20),
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.7),
              scrollBehavior: const MaterialScrollBehavior().copyWith(overscroll: false),
              itemBuilder: (context, index) {
                return SearchPlacard(list: Get.find<SearchLogic>().state.searchHotList, index: index);
              },
              itemCount: 6,
            ),
          ),
        ),
      ],
    );
  }

  buildIconWithTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.red,
        ),
        const Gap(5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class SearchPlacard extends StatelessWidget {
  final List list;
  final int index;

  SearchPlacard({super.key, required this.list, required this.index});

  //初始偏转距离
  final double initOffset = Get.width * 0.15;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-(initOffset - 20) + index * 2 * (initOffset - 20) / 5, 0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  //设置搜索词
                  state.searchKeyword = list[index]["searchWord"];
                  log("搜索词：${state.searchKeyword}");
                  Get.to(() => const SearchResultPage());
                },
                child: searchItem(list[index], index));
          },
          itemCount: list.length,
        ),
      ),
    );
  }

  Widget searchItem(var item, int index) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Gap(10),
          Text(
            "${index + 1}",
            style: TextStyle(
              fontSize: 16,
              color: index < 3 ? Colors.red : Colors.grey,
            ),
          ),
          const Gap(10),
          Text(
            item["searchWord"],
            style: const TextStyle(
              fontSize: 14,
              //小于3的加粗
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          if (item["iconUrl"] != null)
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(item["iconUrl"]),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
//纵向下划线
class MVerticalDivider extends StatelessWidget {
  const MVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 1,
      height: 12,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey),
      ),
    );
  }
}
