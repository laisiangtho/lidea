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
      ..token = fields[5] as String
      ..userId = (fields[6] ?? '') as String
      ..repo = (fields[7] ?? '') as String;
  }

  @override
  void write(BinaryWriter writer, SettingType obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.token)
      ..writeByte(6)
      ..write(obj.userId)
      ..writeByte(7)
      ..write(obj.repo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
