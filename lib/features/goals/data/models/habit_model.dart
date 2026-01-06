import 'dart:convert';

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
  final int habitColor; //it is the index of the List in which the colors are present

  @HiveField(9)
  final String habitKey;

  // @HiveField(10)
  // final String habitType;

  @HiveField(10)
  final int? currentStreak;

  @HiveField(11)
  final int? bestStreak;

  @HiveField(12)
  final int? totalTrackedDays;

  @HiveField(13)
  final int? totalCompletedDays;

  @HiveField(14)
  final int? totalSkippedDays;

  @HiveField(15)
  final double? completionRate;

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
    //  required this.habitType,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.completionRate = 0.0,
    this.totalCompletedDays = 0,
    this.totalSkippedDays = 0,
    this.totalTrackedDays = 0,
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
    int? habitColor,
    String? habitKey,
    //String? habitType,
    int? currentStreak,
    int? bestStreak,
    int? totalTrackedDays,
    int? totalCompletedDays,
    int? totalSkippedDays,
    double? completionRate,
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
      // habitType: habitType ?? this.habitType,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalCompletedDays: totalCompletedDays ?? this.totalCompletedDays,
      totalSkippedDays: totalSkippedDays ?? this.totalSkippedDays,
      totalTrackedDays: totalTrackedDays ?? this.totalTrackedDays,
      completionRate: completionRate ?? this.completionRate,
    );
  }
}

extension HabitModelMapper on HabitModel {
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'habitValue': habitValue,
      'valueCount': valueCount,
      'streakGoal': streakGoal,
      'isDone': isDone,
      'reminderDays': reminderDays,
      'reminderTime': reminderTime,
      'habitColor': habitColor,
      'habitKey': habitKey,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'totalTrackedDays': totalTrackedDays,
      'totalCompletedDays': totalCompletedDays,
      'totalSkippedDays': totalSkippedDays,
      'completionRate': completionRate,
    };
  }

  static HabitModel fromMap(Map<String, dynamic> map) {
    return HabitModel(
      title: map['title'] as String,
      description: map['description'] as String,
      habitValue: map['habitValue'] as int,
      valueCount: map['valueCount'] as int,
      streakGoal: map['streakGoal'] as int,
      isDone: map['isDone'] as bool,
      reminderDays: List<int>.from(map['reminderDays'] ?? []),
      reminderTime: map['reminderTime'] as String,
      habitColor: map['habitColor'] as int,
      habitKey: map['habitKey'] as String,
      currentStreak: map['currentStreak'] as int? ?? 0,
      bestStreak: map['bestStreak'] as int? ?? 0,
      totalTrackedDays: map['totalTrackedDays'] as int? ?? 0,
      totalCompletedDays: map['totalCompletedDays'] as int? ?? 0,
      totalSkippedDays: map['totalSkippedDays'] as int? ?? 0,
      completionRate: (map['completionRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class HabitCodec extends Codec<HabitModel, Object?> {
  @override
  Converter<HabitModel, Object?> get encoder => _HabitEncoder();

  @override
  Converter<Object?, HabitModel> get decoder => _HabitDecoder();
}

class _HabitEncoder extends Converter<HabitModel, Object?> {
  @override
  Object? convert(HabitModel habit) => habit.toMap();
}

class _HabitDecoder extends Converter<Object?, HabitModel> {
  @override
  HabitModel convert(Object? input) {
    return HabitModelMapper.fromMap(input as Map<String, dynamic>);
  }
}
