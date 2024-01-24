import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'logic.dart';

class MusicPlayPage extends StatefulWidget {
  final Map playItem;

  const MusicPlayPage({Key? key, required this.playItem}) : super(key: key);

  @override
  State<MusicPlayPage> createState() => _MusicPlayPageState();
}

class _MusicPlayPageState extends State<MusicPlayPage> with SingleTickerProviderStateMixin {
  final logic = Get.put(MusicPlayLogic());

  final state = Get.find<MusicPlayLogic>().state;

  @override
  void initState() {
    logic.RController.stop();
    state.songItem = widget.playItem;
    print(state.songItem);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Image.network(
              state.songItem["picUrl"] ?? state.songItem["al"]["picUrl"],
              fit: BoxFit.cover,
              height: Get.height,
              width: Get.width,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  await logic.getSong();
                },
                icon: const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: GetBuilder<MusicPlayLogic>(
                id: "musicName",
                builder: (logic) {
                  return ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.white,
                          Colors.transparent
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              state.songItem["name"],
                              style: const TextStyle(color: Colors.white),
                            ),
                            AutoSizeText(
                              state.songItem?["ar"]?[0]?["name"] ??
                                  state.songItem?["song"]?["artists"]?[0]?["name"] ??
                                  "",
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(logic.RController),
                        child: ClipOval(
                          child: Image.network(
                            state.songItem["picUrl"] ?? state.songItem["al"]["picUrl"],
                            height: Get.width * 0.8,
                            width: Get.width * 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildPlayIcon(Icons.favorite_border, () {}),
                      buildPlayIcon(Icons.file_download, () {}),
                      buildPlayIcon(Icons.comment, () {}),
                      buildPlayIcon(Icons.share, () {}),
                    ],
                  ),
                  const Gap(10),
                  const Divider(
                    height: 1,
                  ),
                  const Gap(10),
                  SizedBox(
                    height: Get.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildPlayIcon(Icons.autorenew_rounded, () {}),
                        buildPlayIcon(Icons.skip_previous, () {}),
                        GestureDetector(
                            child: Icon(
                                state.playState ? Icons.play_circle_fill_outlined : Icons.pause_circle_filled_outlined,
                                size: 50,
                                color: Colors.white),
                            onTap: () async {
                              await logic.getSongUrl();

                            }),
                        buildPlayIcon(Icons.skip_next, () {}),
                        buildPlayIcon(Icons.playlist_play, () {}),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlayIcon(IconData iconData, Function onTap) {
    return GestureDetector(
      onTap: () {},
      child: Icon(
        iconData,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
