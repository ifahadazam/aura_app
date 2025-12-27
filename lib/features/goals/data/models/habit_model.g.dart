// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 1;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitModel(
      title: fields[0] as String,
      description: fields[1] as String,
      habitValue: fields[2] as int,
      valueCount: fields[3] as int,
      streakGoal: fields[4] as int,
      isDone: fields[5] as bool,
      reminderDays: (fields[6] as List).cast<int>(),
      reminderTime: fields[7] as String,
      habitColor: fields[8] as int,
      habitKey: fields[9] as String,
      currentStreak: fields[10] as int?,
      bestStreak: fields[11] as int?,
      completionRate: fields[15] as double?,
      totalCompletedDays: fields[13] as int?,
      totalSkippedDays: fields[14] as int?,
      totalTrackedDays: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.habitValue)
      ..writeByte(3)
      ..write(obj.valueCount)
      ..writeByte(4)
      ..write(obj.streakGoal)
      ..writeByte(5)
      ..write(obj.isDone)
      ..writeByte(6)
      ..write(obj.reminderDays)
      ..writeByte(7)
      ..write(obj.reminderTime)
      ..writeByte(8)
      ..write(obj.habitColor)
      ..writeByte(9)
      ..write(obj.habitKey)
      ..writeByte(10)
      ..write(obj.currentStreak)
      ..writeByte(11)
      ..write(obj.bestStreak)
      ..writeByte(12)
      ..write(obj.totalTrackedDays)
      ..writeByte(13)
      ..write(obj.totalCompletedDays)
      ..writeByte(14)
      ..write(obj.totalSkippedDays)
      ..writeByte(15)
      ..write(obj.completionRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
