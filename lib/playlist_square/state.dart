class PlaylistSquareState {
  PlaylistSquareState() {
    ///Initialize variables
  }

  //普通歌单分类，同时分为 场景、风格、情感
  List playListCatList = [];

  //语种歌单标签
  List langPlayListTags = [];

  //风格歌单
  List stylePlayListTags = [];

  //场景歌单
  List scenePlayListTags = [];

  //情感歌单
  List moodPlayListTags = [];

  //主题歌单
  List themePlayListTags = [];

  //我的默认歌单标签
  List myPlayListTags = [
    "推荐",
    "官方",
    "精品",
    "华语",
    "流行",
    "共享歌单",
    "电子",
    "轻音乐",
    "摇滚",
  ];
}
