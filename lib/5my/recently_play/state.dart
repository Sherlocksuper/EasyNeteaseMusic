class RecentlyPlayState {
  RecentlyPlayState() {
    ///Initialize variables
  }

  //一个type列表，包括歌曲、歌手、专辑、视频、播客
  List<Type> typeList = [
    Type(name: "歌曲", type: "song"),
    Type(name: "视频", type: "video"),
    Type(name: "歌单", type: "playlist"),
    Type(name: "专辑", type: "album"),
    Type(name: "播客", type: "dj"),
  ];
}

//一个类,包括名字，和英文名字
class Type {
  final String name;
  final String type;

  Type({
    required this.name,
    required this.type,
  });
}
