import 'package:hive_flutter/hive_flutter.dart';
part 'habits_values_model.g.dart';

@HiveType(typeId: 3)
class HabitsValuesModel extends HiveObject {
  @HiveField(0)
  final String habitKey;

  @HiveField(1)
  final int habitVlaue;

  HabitsValuesModel({required this.habitKey, required this.habitVlaue});

  HabitsValuesModel copyWith({String? habitKey, int? habitVlaue}) {
    return HabitsValuesModel(
      habitKey: habitKey ?? this.habitKey,
      habitVlaue: habitVlaue ?? this.habitVlaue,
    );
  }
}
