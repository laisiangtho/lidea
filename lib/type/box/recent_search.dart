part of lidea.type;

class BoxOfRecentSearch<E> extends BoxOfAbstract<RecentSearchType> {
  // boxOfRecentSearch addWordHistory
  // bool hasNotHistory(String ord) => this.boxOfRecentSearch.values.firstWhere((e) => stringCompare(e,ord),orElse: ()=>'') == null;
  // bool hasNotHistory(String ord) => this.boxOfRecentSearch.values.firstWhere((e) => stringCompare(e,ord),orElse: () => '')!.isEmpty;

  /// recentSearch is EXIST by word
  /// org:recentSearchExist
  MapEntry<dynamic, RecentSearchType> exist(String ord) {
    return entries.firstWhere(
      (e) => UtilString.stringCompare(e.value.word, ord),
      orElse: () => MapEntry(null, RecentSearchType(word: ord)),
    );
  }

  /// recentSearch UPDATE on exist, if not INSERT
  /// org:recentSearchUpdate
  bool update(String ord) {
    if (ord.isNotEmpty) {
      final ob = exist(ord);
      ob.value.date = DateTime.now();
      ob.value.hit++;
      if (ob.key == null) {
        box.add(ob.value);
      } else {
        box.put(ob.key, ob.value);
      }
      return true;
    }
    return false;
  }

  /// recentSearch DELETE by word
  /// org:recentSearchDelete
  bool delete(String ord) {
    if (ord.isNotEmpty) {
      final ob = exist(ord);
      if (ob.key != null) {
        box.delete(ob.key);
        return true;
      }
    }
    return false;
  }

  // recentSearchClear
  // void boxOfRecentSearchClear() {
  //   boxOfRecentSearch.clear();
  // }

  // int _rsIndex(String word) {
  //   return boxOfRecentSearch.toMap().values.toList().indexWhere((e) => e.word == word);
  // }

  // Future<void> _rsDelete(int index) => boxOfRecentSearch.deleteAt(index);
  // Future<void> favoriteSwitch(String word) {
  //   final index = _rsIndex(word);
  //   if (index >= 0) {
  //     return _rsDelete(index);
  //   } else {
  //     return boxOfRecentSearch.add(
  //       RecentSearchType(
  //         word: word,
  //         date: DateTime.now(),
  //       ),
  //     );
  //   }
  // }

}

// RecentSearch
@HiveType(typeId: 101)
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
      word: o['word'] as String,
      hit: o['hit'] as int,
      date: o['date'] as DateTime,
      lang: (o['lang'] ?? const <String>[]) as List<String>,
    );
  }

  Map<String, dynamic> toJSON() {
    return {'word': word, 'hit': hit, 'date': date, 'lang': lang};
  }
}

class RecentSearchAdapter extends TypeAdapter<RecentSearchType> {
  @override
  final int typeId = 101;

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
