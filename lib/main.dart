import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:wyyapp/config.dart';
import 'package:wyyapp/tab_view/view.dart';
import 'package:wyyapp/utils.dart';

void main() {
  WidgetsBinding instance = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: instance);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log("message rebuilde");
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: PopScope(
        canPop: false,
        onPopInvoked: (value) {
          log("messagehhhhhhhhh");
          moveback();
        },
        child: TabViewPage(),
      ),
      builder: EasyLoading.init(),
      darkTheme: darkThemeData,
    );
  }
}

ThemeData themeData = ThemeData(
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    toolbarHeight: 35,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    elevation: 0,
  ),
  primaryColor: Colors.white,
  cardColor: Colors.white,
  cardTheme: const CardTheme(
    color: Colors.white,
    elevation: 0,
  ),
  canvasColor: Colors.white,
  textTheme: const TextTheme(),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.black,
    ),
  ),
  colorScheme: const ColorScheme.light()
    ..copyWith(
      primary: Colors.white,
      secondary: Colors.black,
    ),
);

ThemeData darkThemeData = ThemeData.dark().copyWith(
  appBarTheme: const AppBarTheme(
    toolbarHeight: 35,
    backgroundColor: Colors.black,
    elevation: 0,
  ),
  cardColor: Colors.black,
  cardTheme: const CardTheme(
    color: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white,
    selectionHandleColor: Colors.white,
  ),
);
