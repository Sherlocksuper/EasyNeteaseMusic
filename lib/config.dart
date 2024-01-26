import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//全局dio
Dio dio = Dio();

//drawer所在的context
late BuildContext drawerContext;

//全局的baseUrl
String baseUrl = "https://service-de3fz6q0-1314462060.gz.tencentapigw.com.cn/release";

Color defaultColor = const Color(0xfff8f9fd);
