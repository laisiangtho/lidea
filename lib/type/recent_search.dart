part of 'package:lidea/type.dart';

// RecentSearch
@HiveType(typeId: 1)
class RecentSearchType {
  @HiveField(0)
  String word;

  @HiveField(1)
  int hit;

  @HiveField(2)
  DateTime? date;

  RecentSearchType({
    this.word = '',
    this.hit = 1,
    this.date,
  });

  factory RecentSearchType.fromJSON(Map<String, dynamic> o) {
    return RecentSearchType(
      word: o["word"] as String,
      hit: o["hit"] as int,
      date: o["date"] as DateTime,
    );
  }

  Map<String, dynamic> toJSON() {
    return {"word": word, "hit": hit, "date": date};
  }
}
