import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/KeepAliveWrapper.dart';
import 'package:wyyapp/search/logic.dart';

final logic = Get.find<SearchLogic>();
final state = Get.find<SearchLogic>().state;

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: state.searchTypes.length,
      child: Scaffold(
        appBar: TabBar(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 10, left: 20, right: 20),
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          indicatorColor: Colors.red,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          tabs: [
            for (var key in state.searchTypes.keys)
              Tab(
                text: state.searchTypes[key]!.title,
              ),
          ],
        ),
        body: TabBarView(
          children: [
            for (var key in state.searchTypes.keys) KeepAliveWrapper(child: BasePage(mapkey: key)),
          ],
        ),
      ),
    );
  }
}

class BasePage extends StatelessWidget {
  final String mapkey;

  const BasePage({super.key, required this.mapkey});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async => {
          await logic.getSearchResult(mapkey),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            //正在加载
            child: CircularProgressIndicator(),
          );
        }
        return GetBuilder<SearchLogic>(
          id: "searchResult",
          builder: (logic) {
            return ListView.separated(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              shrinkWrap: true,
              itemCount: state.searchTypes[mapkey]!.result.length,
              itemBuilder: (context, index) {
                Map item = state.searchTypes[mapkey]!.result[index];
                return MusicItem(
                  title: item["name"] ?? item["nickname"] ?? item["title"],
                  subTitle: item["artists"]?[0]?["name"] ??
                      item["creator"]?["nickname"] ??
                      item["album"]?["name"] ??
                      item["creator"]?[0]?["username"] ??
                      item["ar"]?[0]?["name"] ??
                      item["trans"] ??
                      item["signature"] ??
                      "未知",
                  imageUrl: item["picUrl"] ??
                      item["al"]?["picUrl"] ??
                      item["coverImgUrl"] ??
                      item["avatarUrl"] ??
                      item["cover"] ??
                      item["coverUrl"],
                  isRound: mapkey == "userprofiles" || mapkey == "artists",
                  type: mapkey,
                  onTapTile: () {
                    log("点击了$mapkey的第$index个");
                    logic.ManageOnClick(mapkey, item);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Gap(10);
              },
            );
          },
        );
      },
    );
  }
}

class MusicItem extends StatelessWidget {
  //左侧图片
  final String? imageUrl;
  final bool? isRound;

  //标题和副标题
  final String title;
  final String subTitle;

  //点击事件
  final Function? onTapTile;

  //尾部一个widget 的list
  final List<Widget>? tail;

  //传入一个type ,key值，songs之类的
  //用type来处理点击时间
  final String type;

  const MusicItem({
    super.key,
    required this.title,
    required this.subTitle,
    this.imageUrl,
    this.isRound,
    this.onTapTile,
    this.tail,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTapTile != null) {
          onTapTile!();
        }
      },
      child: Row(
        children: [
          //如果imageUrl不为空，则显示图片
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(isRound == true ? 50 : 5),
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          if (imageUrl != null) const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (title != null)
                  AutoSizeText(
                    title!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                if (subTitle != null)
                  AutoSizeText(
                    subTitle!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          if (tail != null) ...tail!,
          const Gap(10),
        ],
      ),
    );
  }
}
