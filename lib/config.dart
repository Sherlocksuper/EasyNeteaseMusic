import 'dart:typed_data';
import 'dart:ui';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

Dio dio = Dio();

String baseUrl = "https://service-de3fz6q0-1314462060.gz.tencentapigw.com.cn/release";

//color248, 249, 253
Color defaultColor = const Color(0xfff8f9fd);

//传入一个数字，修改这个数字的形式
String changeNumber(int number) {
  if (number > 10000) {
    return "${(number / 10000).toStringAsFixed(1)}万";
  } else {
    return number.toString();
  }
}

Future<void> downLoadFile(String url) async {
  if (await Permission.storage.request().isGranted) {
    var response = await dio.get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    if (result["isSuccess"] == true) {
      EasyLoading.showToast("下载成功");
    } else {
      EasyLoading.showToast("下载失败,请重试");
    }
  } else {
    EasyLoading.showToast("暂无权限");
  }
}

Widget buildRefreshIcon(IndicatorController controller){
  return AnimatedBuilder(
    animation: controller,
    builder: (context, child) {
      return Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: controller.value,
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: controller.value,
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
