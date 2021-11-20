part of 'package:lidea/type.dart';

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
