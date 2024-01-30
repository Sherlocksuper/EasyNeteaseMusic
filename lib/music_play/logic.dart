import 'dart:developer';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'state.dart';

class MusicPlayLogic extends GetxController with GetSingleTickerProviderStateMixin {
  final MusicPlayState state = MusicPlayState();

  late final AnimationController RController = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    RController.dispose();
    super.dispose();
  }
}
