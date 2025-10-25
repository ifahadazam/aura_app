import 'package:hive_flutter/hive_flutter.dart';
part 'tasks_model.g.dart';

@HiveType(typeId: 0)
class TasksModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String notes;
  @HiveField(2)
  final String taskPriority;
  @HiveField(3)
  final String taskDate;
  @HiveField(4)
  final String taskTime;
  @HiveField(5)
  final bool isSetEnabled;
  @HiveField(6)
  final bool isTaskDone;
  @HiveField(7)
  final String taskKey;

  TasksModel({
    required this.title,
    required this.notes,
    required this.taskPriority,
    required this.taskDate,
    required this.taskTime,
    required this.isSetEnabled,
    required this.isTaskDone,
    required this.taskKey,
  });

  /// Returns a **new** TasksModel with overridden fields.
  TasksModel copyWith({
    String? title,
    String? notes,
    bool? isPriorityHigh,
    String? taskDate,
    String? taskTime,
    bool? isSetEnabled,
    bool? isTaskDone,
    String? taskPriority,
    String? taskKey,
  }) {
    return TasksModel(
      title: title ?? this.title,
      notes: notes ?? this.notes,
      taskPriority: taskPriority ?? this.taskPriority,
      taskDate: taskDate ?? this.taskDate,
      taskTime: taskTime ?? this.taskTime,
      isSetEnabled: isSetEnabled ?? this.isSetEnabled,
      isTaskDone: isTaskDone ?? this.isTaskDone,
      taskKey: taskKey ?? this.taskKey,
    );
  }
}
