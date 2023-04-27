part of lidea.type;

class BoxOfSettings<E> extends BoxOfAbstract<SettingsType> {
  /// import data from json `{key:value}` Map<String, dynamic>
  /// Update if no value on box, if not insert
  Future<void> fromJSON(Map<String, dynamic> o) async {
    o.forEach((key, value) {
      final item = box.get(key);
      if (item != null && item.isInBox) {
        // Update
        if (key == 'version') {
          version(value: value);
        }
        if (!item.hasValue) {
          box.put(key, SettingsType(value: value));
        }
      } else {
        // Insert
        box.put(key, SettingsType(value: value));
      }
    });
    // final entries = o.map((key, v) => MapEntry(key, SettingsType(value: v)));
    // box.putAll(entries);
  }

  /// export data to json `{key:value}`
  Map<String, Object?> toJSON() {
    return box.toMap().map((key, val) => MapEntry(key, val.value));
    // return box.values.map((e) => e.toJSON());
    // Iterable<Map<String, Object?>>
    // return box.toMap().entries.map((e) {
    //   return {e.key.toString(): e.value.toJSON()};
    // });
  }

  /// check if outdated
  bool checkVersion(dynamic v) {
    // int.parse(v);(v as int)
    if (v == null) return true;

    return version().asInt != (v as int);
  }

  // private update or insert
  SettingsType _updates({required dynamic key, Object? value}) {
    SettingsType? item = box.get(key);

    if (item != null && item.isInBox) {
      if (value != null) {
        item.value = value;
        item.save();
      }
      return item;
    } else {
      debugPrint('update key:$key value:$value');
      final defaultValue = SettingsType(value: value);
      box.put(key, defaultValue);
      return box.get(key, defaultValue: defaultValue)!;
    }
  }

  /// app version to used check "outdated" data by comparing with box's value
  SettingsType version({Object? value}) {
    return _updates(key: 'version', value: value);
  }

  /// 0 = system 1 = light 2 = dark
  SettingsType mode({Object? value}) {
    return _updates(key: 'mode', value: value);
  }

  SettingsType fontSize({Object? value}) {
    return _updates(key: 'fontSize', value: value);
  }

  void fontSizeModify(bool increase, {double minSize = 7.0, double maxSize = 57}) {
    double size = fontSize().asDouble;
    if (increase) {
      size++;
    } else {
      size--;
    }
    fontSize(value: size.clamp(minSize, maxSize));
  }

  SettingsType searchQuery({Object? value}) {
    return _updates(key: 'searchQuery', value: value);
  }

  SettingsType suggestQuery({Object? value}) {
    return _updates(key: 'suggestQuery', value: value);
  }

  /// '' = system, en, no, my...
  SettingsType locale({Object? value}) {
    return _updates(key: 'locale', value: value);
  }

  SettingsType identify({Object? value}) {
    return _updates(key: 'identify', value: value);
  }

  SettingsType bookId({Object? value}) {
    return _updates(key: 'bookId', value: value);
  }

  SettingsType chapterId({Object? value}) {
    return _updates(key: 'chapterId', value: value);
  }

  SettingsType verseId({Object? value}) {
    return _updates(key: 'verseId', value: value);
  }

  SettingsType parallel({Object? value}) {
    return _updates(key: 'parallel', value: value);
  }
}

@HiveType(typeId: 100)
class SettingsType extends HiveObject {
  @HiveField(0)
  Object? value;

  @HiveField(1)
  DateTime? date;

  SettingsType({this.value, this.date});

  // factory SettingsType.fromJSON(Map<String, dynamic> o) {
  //   // o.forEach((key, value) {
  //   //   SettingsType(value: value)
  //   // });
  //   return [SettingsType()];
  // }

  // static Map<String, SettingsType> fromJSONTesting(Map<String, dynamic> o) {
  //   return o.map((key, val) => MapEntry(key, SettingsType(value: val)));
  // }

  void tmp() {}

  /// is value NULL?
  bool get hasValue => value != null;

  /// get Type of object
  Type get type => value.runtimeType;

  /// get value as Int, returned `0` for none Int
  int get asInt {
    if (!hasValue) return 0;
    if (value is int) {
      return int.parse(asString);
    }
    if (value is double) {
      return (double.parse(asString)).toInt();
    }
    // if (int.tryParse(asString) != null) {
    //   return int.parse(asString);
    // }
    return 0;
  }

  /// get value as Double, returned `0.0` for none Double
  double get asDouble {
    // (value ?? 0.0) as double;
    if (!hasValue) return 0.0;
    if (value is int) {
      return (int.parse(asString)).toDouble();
    }
    if (value is double) {
      return double.parse(asString);
    }
    // if (double.tryParse(asString) != null) {
    //   return double.parse(asString);
    // }
    return 0.0;
  }

  String get asString => (value ?? '').toString();

  @override
  String toString() => asString;

  Object? toJSON() => value;
}

class SettingsAdapter extends TypeAdapter<SettingsType> {
  @override
  final int typeId = 100;

  @override
  SettingsType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return SettingsType()
      ..value = (fields[0] ?? '') as Object
      ..date = (fields[1] is DateTime ? fields[1] : DateTime.now()) as DateTime;
  }

  @override
  void write(BinaryWriter writer, SettingsType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.date ?? DateTime.now());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
