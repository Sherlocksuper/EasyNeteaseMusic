import 'dart:developer';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wyyapp/utils/Song.dart';
import '../search/result.dart';
import 'logic.dart';

class MusicPlayPage extends StatelessWidget {
  MusicPlayPage({Key? key}) : super(key: key);

  final logic = Get.put(MusicPlayLogic());

  final state = Get.find<MusicPlayLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MusicPlayLogic>(
      builder: (logic) {
        return Padding(
          padding: EdgeInsets.only(top: MediaQueryData.fromView(View.of(context)).padding.top),
          child: Material(
            color: Colors.red,
            child: Stack(
              children: [
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: CachedNetworkImage(
                    imageUrl: SongManager.musicItemInfo["picUrl"] ?? SongManager.musicItemInfo["al"]["picUrl"],
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
                                    SongManager.musicItemInfo["ar"]?[0]?["name"] ??
                                        SongManager.musicItemInfo["song"]?["artists"]?[0]?["name"] ??
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
                  //不可以加const，否则状态不会改变
                  body: SongPlay(),
                ),
              ],
            ),
          ),
        );
      },
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

  bool showLyric = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                showLyric = !showLyric;
              });
            },
            child: Center(
              child: showLyric
                  ? SongDetail()
                  : RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(
                        Get.find<MusicPlayLogic>().RController,
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: SongManager.musicItemInfo["picUrl"] ?? SongManager.musicItemInfo["al"]["picUrl"],
                          height: Get.width * 0.8,
                          width: Get.width * 0.8,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildPlayIcon(Icons.favorite_border, () {}),
            buildPlayIcon(Icons.file_download, () {
              SongManager.downloadSongById(SongManager.musicItemInfo["id"].toString());
            }),
            buildPlayIcon(Icons.comment, () {}),
            buildPlayIcon(Icons.share, () {}),
          ],
        ),
        const Gap(10),
        GetBuilder<MusicPlayLogic>(
          id: "progress",
          builder: (logic) {
            return ProgressBar(
              onSeek: (duration) async {},
              onDragUpdate: (details) async {
                SongManager.seekMusic(details.timeStamp);
              },
              progress: SongManager.nowProgress,
              total: SongManager.totalLength,
              baseBarColor: Colors.white,
              thumbColor: Colors.white,
              barHeight: 2,
              thumbRadius: 5,
              timeLabelLocation: TimeLabelLocation.below,
              timeLabelTextStyle: const TextStyle(color: Colors.white),
              progressBarColor: Colors.white,
            );
          },
        ),
        const Gap(10),
        SizedBox(
          height: Get.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.autorenew_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                onTap: () {},
              ),
              GestureDetector(
                child: const Icon(Icons.skip_previous, size: 50, color: Colors.white),
                onTap: () {
                  SongManager.playPreviousMusic();
                },
              ),
              GestureDetector(
                child: Icon(
                    SongManager.playerState == PlayerState.playing
                        ? Icons.pause_circle_filled_outlined
                        : Icons.play_circle_fill_outlined,
                    size: 50,
                    color: Colors.white),
                onTap: () async {
                  if (SongManager.playerState == PlayerState.playing) {
                    SongManager.pauseMusic();
                  } else {
                    SongManager.continueMusic();
                  }
                },
              ),
              GestureDetector(
                child: const Icon(Icons.skip_next, size: 50, color: Colors.white),
                onTap: () {
                  SongManager.playNextMusic();
                },
              ),
              GestureDetector(
                child: const Icon(Icons.playlist_play, size: 30, color: Colors.white),
                onTap: () {
                  Get.bottomSheet(
                    GetBuilder<MusicPlayLogic>(
                      builder: (logic) {
                        return Container(
                          height: Get.height * 0.5,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Gap(10),
                                  const Text(
                                    "播放列表",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    Map songItem = SongManager.songListToPlay[index];
                                    bool isPlaying = SongManager.musicItemInfo["id"] == songItem["id"];
                                    return ListTile(
                                      title: Text(
                                        songItem["name"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isPlaying ? Colors.red : Colors.black,
                                        ),
                                      ),
                                      subtitle: Text(
                                        songItem["song"]?["artists"]?[0]?["name"] ??
                                            songItem["ar"]?[0]?["name"] ??
                                            "未知",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isPlaying ? Colors.red : Colors.black,
                                        ),
                                      ),
                                      onTap: () {
                                        SongManager.playMusic(songItem);
                                      },
                                      trailing: IconButton(
                                        onPressed: () {
                                          SongManager.removeSongFromPreparePlayList(songItem);
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    );
                                  },
                                  itemCount: SongManager.songListToPlay.length,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildPlayIcon(IconData iconData, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
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
    return GestureDetector(
      //当手指放到屏幕上的时候
      onTapDown: (details) {},
      child: Stack(
        children: [
          ListWheelScrollView(
            itemExtent: 100,
            diameterRatio: 2.5,
            controller: SongManager.lyricController,
            children: SongManager.songLyric.map((e) {
              return Center(
                child: Text(
                  e["lyric"].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    //字体
                    fontFamily: "XingShu",
                  ),
                ),
              );
            }).toList(),
          ),
          Center(
            child: Container(
              height: 1,
              width: Get.width * 0.8,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
