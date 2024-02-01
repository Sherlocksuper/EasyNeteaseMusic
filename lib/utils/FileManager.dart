import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManager {
  static Dio dio = Dio();

  static Directory? baseDir;

  static bool hasInit = false;

  //用来取消下载
  static final CancelToken cancelToken = CancelToken();

  //初始化  请求权限
  static fmInit() async {
    baseDir = await getApplicationDocumentsDirectory();

    if (await Permission.storage.request().isGranted) {
      log("已授权");
      hasInit = true;
    }
  }

  /// 是否存在
  static Future<bool> isExist(String path) async {
    if (!hasInit) await fmInit();
    File file = File("${baseDir!.path}/$path");
    return file.existsSync();
  }

  //向文件中写入信息
  static Future<bool> writeData(String path, String data) async {
    bool result = false;
    if (!hasInit) fmInit();
    File file = File("${baseDir!.path}/$path");

    log(file.path);

    if (!file.existsSync()) {
      try {
        file.writeAsString(data);
        result = true;
      } catch (e) {
        log(e.toString());
        log("读入错误");
      }
    } else {
      log("歌词文件已存在");
      return true;
    }

    return result;
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

  static Future<bool> downLoad(String url, String path, String name, String format) async {
    bool result = false;

    if (!hasInit) await fmInit();

    String targetPath = "${baseDir!.path}/$path/$name$format";
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
      //打印targetpath
      log(targetPath);
      EasyLoading.showToast("$name$format已下载,不用重复下载");
      return true;
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

  static Future<bool> createDir(String path) async {
    bool result = false;
    if (!hasInit) await fmInit();

    Directory dir = Directory("${baseDir!.path}/$path");
    if (!dir.existsSync()) {
      await dir.create();
      result = true;
    }
    return result;
  }

  //创建file
  static Future<bool> createFile(String path) async {
    if (!hasInit) await fmInit();

    //创建一个文件
    File file = File("${baseDir!.path}/$path");

    if (!await file.exists()) {
      log("歌词文件正在创建");
      await file.create();
      log("歌词文件创建成功");
    } else {
      log("歌词文件已存在");
    }

    return true;
  }

  static getDirList(String s) {
    if (!hasInit) fmInit();
    Directory dir = Directory("${baseDir!.path}/$s");
    return dir.listSync();
  }

  static clearDir(String s) {
    if (!hasInit) fmInit();
    Directory dir = Directory("${baseDir!.path}/$s");
    dir.deleteSync(recursive: true);
  }

  //获取dir
  static String getDir() {
    if (!hasInit) fmInit();
    return baseDir!.path;
  }
}
