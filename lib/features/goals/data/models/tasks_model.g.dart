// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TasksModelAdapter extends TypeAdapter<TasksModel> {
  @override
  final int typeId = 0;

  @override
  TasksModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasksModel(
      title: fields[0] as String,
      notes: fields[1] as String,
      taskPriority: fields[2] as String,
      taskDate: fields[3] as String,
      taskTime: fields[4] as String,
      isSetEnabled: fields[5] as bool,
      isTaskDone: fields[6] as bool,
      taskKey: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TasksModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.notes)
      ..writeByte(2)
      ..write(obj.taskPriority)
      ..writeByte(3)
      ..write(obj.taskDate)
      ..writeByte(4)
      ..write(obj.taskTime)
      ..writeByte(5)
      ..write(obj.isSetEnabled)
      ..writeByte(6)
      ..write(obj.isTaskDone)
      ..writeByte(7)
      ..write(obj.taskKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
