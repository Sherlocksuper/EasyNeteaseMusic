import 'package:flutter/material.dart';

class TabViewState {
  TabViewState() {
    ///Initialize variables
  }

  PageController pageController = PageController(initialPage: 0);

  int currentIndex = 0;

  late BuildContext context;
}
