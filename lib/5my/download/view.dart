import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wyyapp/utils/Song.dart';

import 'logic.dart';

class DownloadPage extends StatelessWidget {
  DownloadPage({Key? key}) : super(key: key);

  final logic = Get.put(DownloadLogic());
  final state = Get.find<DownloadLogic>().state;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async => {
          state.downloadedSong = [],
        },
      ),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('DownloadPage'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: state.downloadedSong.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.downloadedSong[index]["name"]),
                subtitle: Text(state.downloadedSong[index]["artist"] ?? "未知"),
                trailing: IconButton(
                  onPressed: () async {
                    //是否确认
                    bool? isDelete = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("是否删除"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back(result: false);
                              },
                              child: const Text("取消"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await SongManager.deleteSong(state.downloadedSong[index]["path"]);
                                Get.find<DownloadLogic>().update();
                                Get.back();
                              },
                              child: const Text("确认"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
                onTap: () async {
                  // Get.defaultDialog(title: state.downloadedSong.toString());
                  log(SongManager.musicItemInfo.toString());
                },
              );
            },
          ),
        );
      },
    );
  }
}
