import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/Song.dart';
import 'package:wyyapp/config.dart';
import 'logic.dart';

class MusicPlayPage extends StatelessWidget {
  final Map playItem;

  MusicPlayPage({Key? key, required this.playItem}) : super(key: key);

  final logic = Get.put(MusicPlayLogic());

  final state = Get.find<MusicPlayLogic>().state;

  @override
  Widget build(BuildContext context) {
    state.playState = true;
    return Padding(
      padding: EdgeInsets.only(top: MediaQueryData.fromView(View.of(context)).padding.top),
      child: Material(
        color: Colors.white,
        child: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Image.network(
                SongManager.musicItemInfo["picUrl"] ?? SongManager.musicItemInfo["al"]["picUrl"],
                fit: BoxFit.cover,
                height: Get.height,
                width: Get.width,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () async {},
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
                                SongManager.musicItemInfo["name"],
                                style: const TextStyle(color: Colors.white),
                              ),
                              AutoSizeText(
                                SongManager.musicItemInfo?["ar"]?[0]?["name"] ??
                                    SongManager.musicItemInfo?["song"]?["artists"]?[0]?["name"] ??
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
              body: GestureDetector(
                onTap: () {
                  state.showDetail = !state.showDetail;
                  logic.update();
                },
                child: Center(
                  child: GetBuilder<MusicPlayLogic>(
                    builder: (logic) {
                      return !logic.state.showDetail ? SongPlay() : SongDetail();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongPlay extends StatefulWidget {
  const SongPlay({super.key});

  @override
  State<SongPlay> createState() => _SongPlayState();
}

class _SongPlayState extends State<SongPlay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(
                Get.find<MusicPlayLogic>().RController,
              ),
              child: ClipOval(
                child: Image.network(
                  SongManager.musicItemInfo["picUrl"] ?? SongManager.musicItemInfo["al"]["picUrl"],
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
        ProgressBar(
          progress: const Duration(seconds: 0),
          onSeek: (duration) async {},
          total: const Duration(seconds: 0),
          baseBarColor: Colors.white,
          thumbColor: Colors.white,
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
                    SongManager.playerState == PlayerState.playing
                        ? Icons.pause_circle_filled_outlined
                        : Icons.play_circle_fill_outlined,
                    size: 50,
                    color: Colors.white),
                onTap: () async {
                  if (SongManager.playerState == PlayerState.playing) {
                    await SongManager.audioPlayer.pause();
                    Get.find<MusicPlayLogic>().RController.stop();
                  } else {
                    await SongManager.audioPlayer.play(UrlSource(SongManager.musicPlayInfo["url"]));
                    Get.find<MusicPlayLogic>().RController.repeat();
                  }
                  Get.find<MusicPlayLogic>().update();
                },
              ),
              buildPlayIcon(Icons.skip_next, () {}),
              buildPlayIcon(Icons.playlist_play, () {}),
            ],
          ),
        )
      ],
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

//点击之后出现歌词
class SongDetail extends StatelessWidget {
  const SongDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("data"),
      ],
    );
  }
}