import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManager {
  static Dio dio = Dio();

  static Directory? baseDir;

  static get hasInit => baseDir != null;

  //用来取消下载
  static final CancelToken cancelToken = CancelToken();

  //初始化  请求权限
  static fmInit() async {
    baseDir = await getApplicationDocumentsDirectory();

    if (await Permission.storage.request().isGranted) {
      log("已授权");
    } else {
      EasyLoading.showToast("未授权,没有下载权限");
    }
  }

  //读 、写、清空文件

  //向文件中写入信息
  static Future<bool> writeData(String path, String data) async {
    bool result = false;
    if (!hasInit) fmInit();
    File file = File("${baseDir!.path}/$path");
    if (!file.existsSync()) {
      file.writeAsString(data);
      result = true;
    }
    return Future.value(result);
  }

  //读取特定文件数据
  static Future<String> readData(String path) async {
    String result = "";
    if (!hasInit) fmInit();
    File file = File("${baseDir!.path}/$path");
    if (file.existsSync()) {
      result = await file.readAsString();
    }
    return Future.value(result);
  }

  //清空特定文件数据
  static Future<bool> clearData(String path) async {
    bool result = false;
    if (!hasInit) fmInit();
    File file = File("${baseDir!.path}/$path");
    if (file.existsSync()) {
      file.delete();
      result = true;
    }
    return Future.value(result);
  }

  //下载文件

  //参数：path:文件夹路径，name:文件名，format:文件格式，url:下载地址
  static Future<bool> downLoad(String path, String name, String format, String url) async {
    bool result = false;

    if (!hasInit) await fmInit();

    String targetPath = "${baseDir!.path}/$path/$name.$format";
    File file = File(targetPath);
    if (!file.existsSync()) {
      await dio.download(
        url,
        targetPath,
        onReceiveProgress: (count, total) {
          if (total != -1) {
            log("${(count / total * 100).toStringAsFixed(0)}%");
          }
          if (count == total) {
            result = true;
            EasyLoading.showToast("下载完成$name");
          }
        },
      );
    } else {
      EasyLoading.showToast("$name已下载,不用重复下载");
    }
    return result;
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
