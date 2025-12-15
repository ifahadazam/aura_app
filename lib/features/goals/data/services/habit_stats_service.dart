import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:life_goal/features/goals/data/models/habits_values_model.dart';

class HabitStatsService {
  HabitStatsService._internal();
  static final _singleton = HabitStatsService._internal();

  factory HabitStatsService() {
    return _singleton;
  }

  // Get the Current Streak and Best Streak of the Single Habit
  Map<String, dynamic> calculateHabitStreak(
    HabitModel habitModel,
    Box habitValueBox,
    Box allHabits,
  ) {
    String normalizeDate(String date) {
      final p = date.split("-");
      return "${p[0]}-${p[1].padLeft(2, '0')}-${p[2].padLeft(2, '0')}";
    }

    List<String> dateKeys = habitValueBox.keys.cast<String>().toList();

    if (dateKeys.isEmpty) {
      // return {"currentStreak": 0, "bestStreak": 0};
    }

    dateKeys.sort((a, b) {
      final da = DateTime.parse(normalizeDate(a));
      final db = DateTime.parse(normalizeDate(b));
      return da.compareTo(db);
    });

    int bestStreak = 0;
    int currentStreak = 0;
    int tempStreak = 0;

    DateTime? previousDate;

    for (String dateStr in dateKeys) {
      DateTime date = DateTime.parse(normalizeDate(dateStr));

      List<HabitsValuesModel> habitsList = List<HabitsValuesModel>.from(
        habitValueBox.get(dateStr),
      );

      final habit = habitsList.firstWhere(
        (h) => h.habitKey == habitModel.habitKey,
        orElse: () => HabitsValuesModel(
          habitKey: habitModel.habitKey,
          habitVlaue: 0,
          isHabitCompleted: false,
        ),
      );

      bool completedToday = habit.isHabitCompleted;

      if (completedToday) {
        if (previousDate != null && date.difference(previousDate).inDays == 1) {
          tempStreak++;
        } else {
          tempStreak = 1;
        }
      } else {
        tempStreak = 0;
      }

      bestStreak = tempStreak > bestStreak ? tempStreak : bestStreak;

      previousDate = date;
    }

    // Check today's streak
    final now = DateTime.now();
    final todayStr =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    if (habitValueBox.containsKey(todayStr)) {
      List<HabitsValuesModel> todayList = List<HabitsValuesModel>.from(
        habitValueBox.get(todayStr),
      );

      final todayHabit = todayList.firstWhere(
        (h) => h.habitKey == habitModel.habitKey,
        orElse: () => HabitsValuesModel(
          habitKey: habitModel.habitKey,
          habitVlaue: 0,
          isHabitCompleted: false,
        ),
      );

      currentStreak = todayHabit.isHabitCompleted ? tempStreak : 0;
    } else {
      currentStreak = 0;
    }
    final updatedHabit = habitModel.copyWith(
      bestStreak: bestStreak,
      currentStreak: currentStreak,
    );

    log('Current Streak : $currentStreak');
    log('Best Streak : $bestStreak');
    allHabits.put(habitModel.habitKey, updatedHabit);

    return {"currentStreak": currentStreak, "bestStreak": bestStreak};
  }

  DateTime? parseDate(String date) {
    final parts = date.split("-");
    if (parts.length != 3) return null;

    return DateTime(
      int.parse(parts[0]), // year
      int.parse(parts[1]), // month
      int.parse(parts[2]), // day
    );
  }

  Future<int> totalDaysTracked(
    Box habitsBox,
    Box allHabits,
    HabitModel habitModel,
  ) async {
    final allDateKeys = habitsBox.keys.cast<String>().toList()
      ..sort((a, b) => parseDate(a)!.compareTo(parseDate(b)!));

    DateTime? firstCompletedDate;
    DateTime? lastCompletedDate;

    for (final dateKey in allDateKeys) {
      final list = habitsBox.get(dateKey);

      if (list.any((item) => item.isHabitCompleted == true)) {
        final parsed = parseDate(dateKey)!;
        firstCompletedDate ??= parsed;
        lastCompletedDate = parsed;
      }
    }

    if (firstCompletedDate == null || lastCompletedDate == null) {
      return 0;
    }

    final diff =
        lastCompletedDate
            .difference(
              DateTime(
                firstCompletedDate.year,
                firstCompletedDate.month,
                firstCompletedDate.day,
              ),
            )
            .inDays +
        1;

    log('Total Days Tracked: $diff');

    final updatedHabit = habitModel.copyWith(totalTrackedDays: diff);
    await allHabits.put(habitModel.habitKey, updatedHabit);

    return diff;
  }

  Future<int> totalCompleted(
    Box habitsBox,
    Box allHabits,
    HabitModel habitModel,
  ) async {
    final allDateKeys = habitsBox.keys.cast<String>().toList();

    int completedDays = 0;

    for (final dateKey in allDateKeys) {
      final list = habitsBox.get(dateKey);

      final bool anyCompleted = list.any(
        (item) => item.isHabitCompleted == true,
      );

      if (anyCompleted) {
        completedDays++;
      }
    }

    log('Total Completed: $completedDays');

    final updatedHabit = habitModel.copyWith(totalCompletedDays: completedDays);
    await allHabits.put(habitModel.habitKey, updatedHabit);

    return completedDays;
  }

  Future<int> skippedDays(
    Box habitsBox,
    Box allHabits, // not used, kept for consistency
    HabitModel habitModel,
  ) async {
    int skippedDays = 0;
    final allDateKeys = habitsBox.keys.cast<String>().toList();

    if (allDateKeys.isEmpty) return 0;

    allDateKeys.sort((a, b) => parseDate(a)!.compareTo(parseDate(b)!));

    DateTime? firstCompletedDate;
    DateTime? lastCompletedDate;
    int completedDays = 0;

    // ---- Find first & last completed date + count completed days
    for (final dateKey in allDateKeys) {
      final list = habitsBox.get(dateKey);

      final bool completed = list.any(
        (item) =>
            item.habitKey == habitModel.habitKey &&
            item.isHabitCompleted == true,
      );

      if (completed) {
        completedDays++;
        final parsed = parseDate(dateKey)!;
        firstCompletedDate ??= parsed;
        lastCompletedDate = parsed;
      }
    }

    // ---- No completion at all
    if (firstCompletedDate == null || lastCompletedDate == null) {
      return 0;
    }

    // ✅ EDGE CASE: only one completed day
    if (firstCompletedDate.isAtSameMomentAs(lastCompletedDate)) {
      return 0;
    }

    // ---- Total days between first & last completion (inclusive)
    final int totalDaysInRange =
        lastCompletedDate
            .difference(
              DateTime(
                firstCompletedDate.year,
                firstCompletedDate.month,
                firstCompletedDate.day,
              ),
            )
            .inDays +
        1;

    skippedDays = totalDaysInRange - completedDays;

    log('Total days in range: $totalDaysInRange');
    log('Completed days: $completedDays');
    log('Skipped days (missing + false): $skippedDays');

    return skippedDays;
  }

  Future<double> completionRate(
    Box habitsBox,
    Box allHabits,
    HabitModel habitModel,
  ) async {
    final totalDays = await totalDaysTracked(habitsBox, allHabits, habitModel);
    final totalCompletionDays = await totalCompleted(
      habitsBox,
      allHabits,
      habitModel,
    );

    if (totalDays == 0) return 0.0;

    final rate = totalCompletionDays / totalDays;

    log('Completion Rate: ${(rate * 100).toStringAsFixed(2)}');

    final updatedHabit = habitModel.copyWith(completionRate: rate);
    await allHabits.put(habitModel.habitKey, updatedHabit);

    return rate * 100;
  }

  HabitModel resetHabitStats(HabitModel habit) {
    return habit.copyWith(
      bestStreak: 0,
      currentStreak: 0,
      totalTrackedDays: 0,
      totalCompletedDays: 0,
      totalSkippedDays: 0,
      completionRate: 0.0,
    );
  }

  Future<void> calculateHabitStats({
    required Box habitsBox,
    required Box allHabits,
    required HabitModel habitModel,
  }) async {
    // 🔴 RESET FIRST (prevents stale values)
    await allHabits.put(habitModel.habitKey, resetHabitStats(habitModel));

    DateTime? parseDate(String date) {
      final parts = date.split("-");
      if (parts.length != 3) return null;

      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }

    final List<String> dateKeys = habitsBox.keys.cast<String>().toList();
    if (dateKeys.isEmpty) return;

    dateKeys.sort((a, b) => parseDate(a)!.compareTo(parseDate(b)!));

    DateTime? firstCompletedDate;
    DateTime? lastCompletedDate;
    int completedDays = 0;

    for (final dateKey in dateKeys) {
      final list = habitsBox.get(dateKey);

      final bool completed = list.any(
        (item) =>
            item.habitKey == habitModel.habitKey &&
            item.isHabitCompleted == true,
      );

      if (completed) {
        completedDays++;
        final parsedDate = parseDate(dateKey)!;
        firstCompletedDate ??= parsedDate;
        lastCompletedDate = parsedDate;
      }
    }

    if (firstCompletedDate == null || lastCompletedDate == null) return;

    final int totalTrackedDays =
        lastCompletedDate.difference(firstCompletedDate).inDays + 1;

    final double completionRate = completedDays / totalTrackedDays;

    final streak = calculateHabitStreak(habitModel, habitsBox, allHabits);
    final skippedCount = await skippedDays(habitsBox, allHabits, habitModel);

    await allHabits.put(
      habitModel.habitKey,
      habitModel.copyWith(
        bestStreak: streak['bestStreak'],
        currentStreak: streak['currentStreak'],
        totalTrackedDays: totalTrackedDays,
        totalCompletedDays: completedDays,
        totalSkippedDays: skippedCount,
        completionRate: completionRate,
      ),
    );
  }
}
