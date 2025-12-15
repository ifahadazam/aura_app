// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_values_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitsValuesModelAdapter extends TypeAdapter<HabitsValuesModel> {
  @override
  final int typeId = 3;

  @override
  HabitsValuesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitsValuesModel(
      habitKey: fields[0] as String,
      habitVlaue: fields[1] as int,
      isHabitCompleted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HabitsValuesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.habitKey)
      ..writeByte(1)
      ..write(obj.habitVlaue)
      ..writeByte(2)
      ..write(obj.isHabitCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitsValuesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
