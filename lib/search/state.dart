class SearchState {
  //搜索词
  String searchKeyword = "";

  //默认搜索关键词
  String searchDefault = "";

  //热门列表
  List searchHotList = [];

  //搜索建议
  List searchSuggest = [];

  //**************搜索结果****************

  Map<String, SearchType> searchTypes = {
    "songs": SearchType(title: "单曲", type: 1, result: [], name: "songs"),
    "albums": SearchType(title: "专辑", type: 10, result: [], name: "albums"),
    "artists": SearchType(title: "歌手", type: 100, result: [], name: "artists"),
    "playlists": SearchType(title: "歌单", type: 1000, result: [], name: "playlists"),
    "userprofiles": SearchType(title: "用户", type: 1002, result: [], name: "userprofiles"),
    "mv": SearchType(title: "MV", type: 1004, result: [], name: "mv"),
    "djRadios": SearchType(title: "电台", type: 1009, result: [], name: "djRadios"),
    "video": SearchType(title: "视频", type: 1014, result: [], name: "video"),
    // "audio": SearchType(title: "声音", type: 2000, result: [], name: "audio"),
  };

  SearchState() {
    ///Initialize variables
  }
}

class SearchType {
  String title = "";
  int type = 0;
  List result = [];
  String name = "";

  SearchType({required this.title, required this.type, required this.result, required String name});
}
