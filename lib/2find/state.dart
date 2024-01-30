import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FindState {
  FindState() {
    ///Initialize variables
  }

  List<Map> functionList = [];

  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
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
    ..loadRequest(Uri.parse('https://music.163.com/v/m/album/poly/detail'));
}

//{
//             "id": 1025001,
//             "name": "有声书",
//             "iconUrl": "http://p1.music.126.net/Kb4oK0m_ocs3FR3lo-r9yg==/109951167319110429.jpg",
//             "url": "orpheus://rnpage?component=rn-podcast-book&route=book-home&split=book-home&focusTab=book&mainProcessCompat=1",
//             "skinSupport": true,
//             "homepageMode": "RCMD_MODE",
//             "resourceState": null
//         },
