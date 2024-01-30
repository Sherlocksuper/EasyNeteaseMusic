import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../KeepAliveWrapper.dart';
import '../config.dart';
import 'logic.dart';

class FindPage extends StatelessWidget {
  FindPage({Key? key}) : super(key: key);

  final logic = Get.put(FindLogic());
  final state = Get.find<FindLogic>().state;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () => {
          state.controller = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                },
                onPageStarted: (String url) {},
                onPageFinished: (String url) {},
                onWebResourceError: (WebResourceError error) {},
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(Uri.parse('https://music.163.com/v/m/album/poly/detail'))
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return DefaultTabController(
          length: state.functionList.length,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 40,
              leading: IconButton(
                onPressed: () async {
                  Scaffold.of(drawerContext).openDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
              title: const Text("发现"),
              actions: [
                IconButton(
                  onPressed: () {
                    log("点击了搜索");
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            body: WebViewWidget(controller: state.controller),
          ),
        );
      },
    );
  }
}
