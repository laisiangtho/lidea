part of 'main.dart';

// RecentSearch
@HiveType(typeId: 1)
class RecentSearchType {
  @HiveField(0)
  String word;

  @HiveField(1)
  int hit;

  @HiveField(2)
  DateTime? date;

  @HiveField(3)
  List<String> lang;

  RecentSearchType({
    this.word = '',
    this.hit = 0,
    this.date,
    this.lang = const [],
  });

  factory RecentSearchType.fromJSON(Map<String, dynamic> o) {
    return RecentSearchType(
      word: o["word"] as String,
      hit: o["hit"] as int,
      date: o["date"] as DateTime,
      lang: (o["lang"] ?? const <String>[]) as List<String>,
    );
  }

  Map<String, dynamic> toJSON() {
    return {"word": word, "hit": hit, "date": date, "lang": lang};
  }
}

class RecentSearchAdapter extends TypeAdapter<RecentSearchType> {
  @override
  final int typeId = 1;

  @override
  RecentSearchType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentSearchType()
      ..word = fields[0] as String
      ..hit = fields[1] as int
      ..date = fields[2] as DateTime
      ..lang = (fields[3] ?? const <String>[]) as List<String>;
  }

  @override
  void write(BinaryWriter writer, RecentSearchType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.word)
      ..writeByte(1)
      ..write(obj.hit)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.lang);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentSearchAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
