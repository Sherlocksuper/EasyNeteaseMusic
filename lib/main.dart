import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:wyyapp/tab_view/view.dart';

void main() {
  WidgetsBinding instance = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: instance);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: TabViewPage(),
      builder: EasyLoading.init(),
      theme: themeData,
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
);

ThemeData darkThemeData = ThemeData.dark().copyWith(
  appBarTheme: const AppBarTheme(
    toolbarHeight: 35,
    backgroundColor: Colors.black,
    elevation: 0,
  ),
);
