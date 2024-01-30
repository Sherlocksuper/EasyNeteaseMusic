import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'logic.dart';

class BatchManagerPage extends StatelessWidget {
  //需要操作的song列表
  final List songList;
  final BatchType type;

  BatchManagerPage({Key? key, required this.songList, required this.type}) : super(key: key);

  final logic = Get.put(BatchManagerLogic());
  final state = Get.find<BatchManagerLogic>().state;

  @override
  Widget build(BuildContext context) {
    state.batchList.addAll(songList);

    return GetBuilder<BatchManagerLogic>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('批量管理'),
          centerTitle: true,
          //已选择
          actions: [
            TextButton(
              onPressed: () {
                state.batchList = [];
                logic.update();
              },
              child: Text('已选择${state.batchList.length}首'),
            ),
          ],
        ),
        //一个列表
        body: Column(
          children: [
            //全选
            ListTile(
              title: const Text('全选'),
              trailing: Checkbox(
                shape: const CircleBorder(),
                value: state.batchList.length == songList.length,
                onChanged: (value) {
                  if (value == true) {
                    state.batchList.addAll(songList);
                  } else {
                    state.batchList = [];
                  }
                  logic.update();
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  Map item = songList[index];
                  return ListTile(
                    title: Text(songList[index]['name']),
                    subtitle: Text(songList[index]['ar'][0]['name']),
                    trailing: Checkbox(
                      shape: const CircleBorder(),
                      value: state.batchList.contains(item),
                      onChanged: (value) {
                        if (value == true) {
                          state.batchList.add(item);
                        } else {
                          state.batchList.remove(item);
                        }
                        logic.update();
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (state.batchList.isEmpty) {
                  EasyLoading.showToast('请选择至少一首歌曲哦~');
                  return;
                }
                logic.doBatch(type);
              },
              //确定下载、确定添加
              child: Text(type == BatchType.download ? '确定下载' : '确定添加'),
            ),
          ],
        ),
      );
    });
  }
}

enum BatchType {
  addToPlaylist,
  download,
}
