import 'dart:async';
import 'dart:html';

import 'package:dio/dio.dart';

final dio = Dio();

class Debouncer {
  //防抖的时间,可以自行定义
  final Duration? delay;
  Timer? _timer;

  Debouncer({this.delay});

  call(Function action) {
    print(action);
    //如果timer不等于null,那么取消这个timer
    if (_timer != null) {
      _timer!.cancel();
    }
    //再新建一个timer来重新计时
    _timer = Timer(delay!, () {
      action();
    });
  }
}

//这个只进行第一个或者timer为null的时候

class throttle {
  final Duration delay;
  Timer? _timer;

  throttle({required this.delay});

  call(Function action) {
    //如果_timer为null就执行
    if (_timer == null) {
      action();
    } else {
      _timer = Timer(delay, () {
        action();
      });
    }
  }
}

//定义一个全局的防抖
final debouncer = Debouncer(delay: const Duration(milliseconds: 500));

void main() async {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      //把options打印出来
      print(options.uri.toString());
      print(options.method);
      print(options.path);
      debouncer(() => handler.next(options));
    },
  ));

  print("haha");
  int index = 0;
  //循环
  Timer.periodic(const Duration(milliseconds: 300), (timer) async {
    index++;
    print("第$index次请求");
    var test = await dio.get('https://jsonplaceholder.typicode.com/posts/1');
    print(test.toString());
  });
}
