import 'dart:developer';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config.dart';

class FileManager {
  static Directory? baseDir;

  static get hasInit => baseDir != null;

  //初始化
  static fmInit() async {
    baseDir = await getApplicationDocumentsDirectory();

    if (await Permission.storage.request().isGranted) {
      log("已授权");
    } else {
      EasyLoading.showToast("未授权,没有下载权限");
    }
  }

  //参数：path:文件夹路径，name:文件名，format:文件格式，url:下载地址
  static Future<bool> downLoad(String path, String name, String format, String url) async {
    bool result = false;
    if (!hasInit) {
      await fmInit();
    }
    String targetPath = "${baseDir!.path}/$path/$name.$format";
    File file = File(targetPath);
    if (!file.existsSync()) {
      await dio.download(url, targetPath, onReceiveProgress: (received, total) {
        if (total != -1) {
          log("${(received / total * 100).toStringAsFixed(0)}%");
        }
        if (received == total) {
          result = true;
          EasyLoading.showToast("下载完成$name");
        }
      });
    } else {
      EasyLoading.showToast("$name已下载,不用重复下载");
    }
    return result;
  }

  //列出固定path的所有文件并返回
  static Future<List<Map>> listFiles(String path) async {
    if (!hasInit) {
      await fmInit();
    }
    List<FileSystemEntity> files = Directory("${baseDir!.path}/$path").listSync();
    List<Map> songList = [];
    for (var file in files) {
      songList.add({
        "name": file.path.split("/").last.split(".").first,
        "path": file.path,
      });
    }
    return songList;
  }

  //删除文件
  static Future<bool> deleteFile(String targetPath) async {
    bool result = false;
    if (!hasInit) await fmInit();
    File file = File(targetPath);
    if (file.existsSync()) {
      await file.delete();
      result = true;
    }
    return result;
  }
}
