import 'package:audioplayers/audioplayers.dart';

class MusicPlayState {
  MusicPlayState() {
    ///Initialize variables
  }

  bool playState = true;

  bool showDetail = false;

  String songUrl = '';

  Duration duration = const Duration();
}
