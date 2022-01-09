part of 'main.dart';

@HiveType(typeId: 0)
class SettingType {
  @HiveField(0)
  int version;

  // 0 = system 1 = light 2 = dark
  @HiveField(1)
  int mode;

  @HiveField(2)
  double fontSize;

  @HiveField(3)
  String searchQuery;

  // '' = system, en, no, my...
  @HiveField(4)
  String locale;

  @HiveField(5)
  String identify;
  @HiveField(6)
  int bookId;
  @HiveField(7)
  int chapterId;
  @HiveField(8)
  int verseId;

  @HiveField(9)
  String parallel;

  SettingType({
    this.version = 0,
    this.mode = 0,
    this.fontSize = 17.0,
    this.searchQuery = '',
    this.locale = '',
    this.identify: '',
    this.bookId: 1,
    this.chapterId: 1,
    this.verseId: 1,
    this.parallel: '',
  });

  factory SettingType.fromJSON(Map<String, dynamic> o) {
    return SettingType(
      version: o["version"] as int,
      mode: o["mode"] as int,
      fontSize: o["fontSize"] as double,
      searchQuery: o["searchQuery"] as String,
      locale: o["locale"] as String,
      identify: (o["identify"] ?? '') as String,
      bookId: (o["bookId"] ?? '') as int,
      chapterId: (o["chapterId"] ?? '') as int,
      verseId: (o["verseId"] ?? '') as int,
      parallel: (o["identify"] ?? '') as String,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "version": version,
      "mode": mode,
      "fontSize": fontSize,
      "searchQuery": searchQuery,
      "locale": locale,
      // "token": token,
      // "userId": userId,
      // "repo": repo,
    };
  }

  SettingType merge(SettingType o) {
    return SettingType(
      version: o.version,
      mode: o.mode,
      fontSize: o.fontSize,
      searchQuery: o.searchQuery,
      locale: o.locale,
      identify: o.identify,
      bookId: o.bookId,
      chapterId: o.chapterId,
      verseId: o.verseId,
      parallel: o.parallel,
    );
  }

  SettingType copyWith({
    int? version,
    int? mode,
    double? fontSize,
    String? searchQuery,
    String? locale,
    String? identify,
    int? bookId,
    int? chapterId,
    int? verseId,
    String? parallel,
  }) {
    return SettingType(
      version: version ?? this.version,
      mode: mode ?? this.mode,
      fontSize: fontSize ?? this.fontSize,
      searchQuery: searchQuery ?? this.searchQuery,
      locale: locale ?? this.locale,
      identify: identify ?? this.identify,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      verseId: verseId ?? this.verseId,
      parallel: parallel ?? this.parallel,
    );
  }
}
