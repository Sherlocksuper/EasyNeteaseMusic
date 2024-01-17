import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wyyapp/login/view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ShowPage(),
      builder: EasyLoading.init(),
      theme: themeData,
      darkTheme: darkThemeData,
    );
  }
}

ThemeData themeData = ThemeData(
  appBarTheme: const AppBarTheme(
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
);

ThemeData darkThemeData = ThemeData.dark().copyWith(
  appBarTheme: const AppBarTheme(
    toolbarHeight: 35,
    backgroundColor: Colors.black,
    elevation: 0,
  ),
);
