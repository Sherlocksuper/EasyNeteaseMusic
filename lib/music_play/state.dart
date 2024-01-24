import 'package:audioplayers/audioplayers.dart';

class MusicPlayState {
  MusicPlayState() {
    ///Initialize variables
  }

  bool playState = false;

  String songUrl = '';

  Map songItem = {};

  final player = AudioPlayer();
}
