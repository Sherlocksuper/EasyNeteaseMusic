import 'dart:async';
import 'dart:html';

import 'package:dio/dio.dart';

final dio = Dio();

Timer? timer;

//防抖
//只进行最后一次请求
void myDebounce(Function test) {
  Duration duration = const Duration(milliseconds: 500);

  if (timer == null) {
    test();
  }
}

void main() {}
