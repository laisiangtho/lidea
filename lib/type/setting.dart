part of 'package:lidea/type.dart';

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

  // token, user file
  @HiveField(5)
  String token;
  @HiveField(6)
  String userId;
  @HiveField(7)
  String repo;

  SettingType({
    this.version = 0,
    this.mode = 0,
    this.fontSize = 17.0,
    this.searchQuery = '',
    this.locale = '',
    this.token = '',
    this.userId = '',
    this.repo = '',
  });

  factory SettingType.fromJSON(Map<String, dynamic> o) {
    return SettingType(
      version: o["version"] as int,
      mode: o["mode"] as int,
      fontSize: o["fontSize"] as double,
      searchQuery: o["searchQuery"] as String,
      locale: o["locale"] as String,
      token: (o["token"] ?? '') as String,
      userId: (o["userId"] ?? '') as String,
      repo: (o["file"] ?? '') as String,
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
      "userId": userId,
      "repo": repo,
    };
  }

  SettingType merge(SettingType o) {
    return SettingType(
      version: o.version,
      mode: o.mode,
      fontSize: o.fontSize,
      searchQuery: o.searchQuery,
      locale: o.locale,
      token: o.token,
      userId: o.userId,
      repo: o.repo,
    );
  }

  SettingType copyWith({
    int? version,
    int? mode,
    double? fontSize,
    String? searchQuery,
    String? locale,
    String? token,
    String? userId,
    String? repo,
  }) {
    return SettingType(
      version: version ?? this.version,
      mode: mode ?? this.mode,
      fontSize: fontSize ?? this.fontSize,
      searchQuery: searchQuery ?? this.searchQuery,
      locale: locale ?? this.locale,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      repo: repo ?? this.repo,
    );
  }
}
