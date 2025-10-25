import 'package:hive_flutter/hive_flutter.dart';
part 'habit_model.g.dart';

@HiveType(typeId: 1)
class HabitModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int habitValue;

  // If valueCount == 0 then the habitValue can either be 0 or 1
  // If valueCount > 0 then the habitValue can either be any integer

  @HiveField(3)
  final int valueCount;

  @HiveField(4)
  final int streakGoal;

  @HiveField(5)
  final bool isDone;

  @HiveField(6)
  final List<int> reminderDays;

  @HiveField(7)
  final String reminderTime;

  @HiveField(8)
  final String habitColor;

  @HiveField(9)
  final String habitKey;

  @HiveField(10)
  final String habitType;

  HabitModel({
    required this.title,
    required this.description,
    required this.habitValue,
    required this.valueCount,
    required this.streakGoal,
    required this.isDone,
    required this.reminderDays,
    required this.reminderTime,
    required this.habitColor,
    required this.habitKey,
    required this.habitType,
  });

  HabitModel copyWith({
    String? title,
    String? description,
    int? habitValue,
    int? valueCount,
    int? streakGoal,
    bool? isDone,
    List<int>? reminderDays,
    String? reminderTime,
    String? habitColor,
    String? habitKey,
    String? habitType,
  }) {
    return HabitModel(
      title: title ?? this.title,
      description: description ?? this.description,
      habitValue: habitValue ?? this.habitValue,
      valueCount: valueCount ?? this.valueCount,
      streakGoal: streakGoal ?? this.streakGoal,
      isDone: isDone ?? this.isDone,
      reminderDays: reminderDays ?? List<int>.from(this.reminderDays),
      reminderTime: reminderTime ?? this.reminderTime,
      habitColor: habitColor ?? this.habitColor,
      habitKey: habitKey ?? this.habitKey,
      habitType: habitType ?? this.habitType,
    );
  }
}
