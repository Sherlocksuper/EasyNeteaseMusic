import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wyyapp/batch_manager/view.dart';
import 'package:wyyapp/utils/Song.dart';

import 'state.dart';

class BatchManagerLogic extends GetxController {
  final BatchManagerState state = BatchManagerState();

  //根据type执行不同的操作
  void doBatch(BatchType type) {
    switch (type) {
      case BatchType.download:
        break;
      case BatchType.addToPlaylist:
        for (var element in state.batchList) {
          SongManager.addSongToPreparePlayList(element);
        }
        EasyLoading.showToast("已添加到播放列表");
        break;
    }
  }
}
