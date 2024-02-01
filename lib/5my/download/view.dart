import 'dart:developer';
import 'dart:io';

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
          state.downloadedSong = await SongManager.getLocalSong(),
          log(state.downloadedSong.toString()),
          log("message"),
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('DownloadPage'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  //是否确定删除
                  Get.defaultDialog(
                    title: "是否删除全部",
                    middleText: "删除后将无法恢复",
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back(result: false);
                        },
                        child: const Text("取消"),
                      ),
                      TextButton(
                        onPressed: () {
                          SongManager.clearDownloadDir();
                          Get.find<DownloadLogic>().update();
                          Get.back();
                        },
                        child: const Text("确认"),
                      ),
                    ],
                  );
                },
                icon: const Icon(Icons.delete_forever),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: state.downloadedSong.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: ClipOval(
                  child: Image.file(
                    File(
                      SongManager.getPath(state.downloadedSong[index]["id"].toString(), ".png"),
                    ),
                  ),
                ),
                title: Text(state.downloadedSong[index]["name"]),
                subtitle: Text(state.downloadedSong[index]['ar']?[0]?['name'] ?? "未知"),
                trailing: IconButton(
                  onPressed: () async {
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
                                // await SongManager.deleteSong(state.downloadedSong[index]["path"]);
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
