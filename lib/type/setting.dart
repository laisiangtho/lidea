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

class SettingAdapter extends TypeAdapter<SettingType> {
  @override
  final int typeId = 0;

  @override
  SettingType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingType()
      ..version = fields[0] as int
      ..mode = fields[1] as int
      ..fontSize = fields[2] as double
      ..searchQuery = fields[3] as String
      ..locale = fields[4] as String
      ..identify = fields[5] as String
      ..bookId = fields[6] as int
      ..chapterId = fields[7] as int
      ..verseId = fields[8] as int
      ..parallel = fields[9] as String;
  }

//  identify: o.identify,
//       bookId: o.bookId,
//       chapterId: o.chapterId,
//       verseId: o.verseId,
//       parallel: o.parallel,
  @override
  void write(BinaryWriter writer, SettingType obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.version)
      ..writeByte(1)
      ..write(obj.mode)
      ..writeByte(2)
      ..write(obj.fontSize)
      ..writeByte(3)
      ..write(obj.searchQuery)
      ..writeByte(4)
      ..write(obj.locale)
      ..writeByte(5)
      ..write(obj.identify)
      ..writeByte(6)
      ..write(obj.bookId)
      ..writeByte(7)
      ..write(obj.chapterId)
      ..writeByte(8)
      ..write(obj.verseId)
      ..writeByte(9)
      ..write(obj.parallel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
