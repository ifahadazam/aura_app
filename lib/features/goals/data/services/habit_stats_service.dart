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
    final todayStr = '${now.year}-${now.month}-${now.day}';

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
    Box habitsValuesBox,
    Box allHabits,
    HabitModel habitModel,
  ) async {
    final allDateKeys = habitsValuesBox.keys.cast<String>().toList()
      ..sort((a, b) => parseDate(a)!.compareTo(parseDate(b)!));

    DateTime? firstCompletedDate;
    DateTime? lastCompletedDate;

    for (final dateKey in allDateKeys) {
      final list = habitsValuesBox.get(dateKey);

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
    Box habitsValuesBox,
    Box allHabits,
    HabitModel habitModel,
  ) async {
    final allDateKeys = habitsValuesBox.keys.cast<String>().toList();

    int completedDays = 0;

    for (final dateKey in allDateKeys) {
      final list = habitsValuesBox.get(dateKey);

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
    Box habitsValuesBox,
    Box allHabits, // not used, kept for consistency
    HabitModel habitModel,
  ) async {
    int skippedDays = 0;
    final allDateKeys = habitsValuesBox.keys.cast<String>().toList();

    if (allDateKeys.isEmpty) return 0;

    allDateKeys.sort((a, b) => parseDate(a)!.compareTo(parseDate(b)!));

    DateTime? firstCompletedDate;
    DateTime? lastCompletedDate;
    int completedDays = 0;

    // ---- Find first & last completed date + count completed days
    for (final dateKey in allDateKeys) {
      final list = habitsValuesBox.get(dateKey);

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
    Box habitsValuesBox,
    Box allHabits,
    HabitModel habitModel,
  ) async {
    final totalDays = await totalDaysTracked(
      habitsValuesBox,
      allHabits,
      habitModel,
    );
    final totalCompletionDays = await totalCompleted(
      habitsValuesBox,
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
    required Box habitsValueBox,
    required Box allHabitsBox,
    required HabitModel habitModel,
  }) async {
    // 🔴 RESET FIRST (prevents stale values)
    await allHabitsBox.put(habitModel.habitKey, resetHabitStats(habitModel));

    DateTime? parseDate(String date) {
      final parts = date.split("-");
      if (parts.length != 3) return null;

      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }

    final List<String> dateKeys = habitsValueBox.keys.cast<String>().toList();
    if (dateKeys.isEmpty) return;

    dateKeys.sort((a, b) => parseDate(a)!.compareTo(parseDate(b)!));

    DateTime? firstCompletedDate;
    DateTime? lastCompletedDate;
    int completedDays = 0;

    for (final dateKey in dateKeys) {
      final list = habitsValueBox.get(dateKey);

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

    final streak = calculateHabitStreak(
      habitModel,
      habitsValueBox,
      allHabitsBox,
    );
    final skippedCount = await skippedDays(
      habitsValueBox,
      allHabitsBox,
      habitModel,
    );

    await allHabitsBox.put(
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

  // Stats for the Graphs
  //* Weekly (Past 7 Days Habits Completion Count indcluding current day)
  Map<String, Map<String, dynamic>> getLast7DaysHabitCompletion({
    required Box habitsBox,
  }) {
    final Map<String, Map<String, dynamic>> result = {};

    // ✅ Format: yyyy-MM-dd
    String formatDate(DateTime date) {
      final y = date.year.toString();
      final m = date.month.toString(); // no padding
      final d = date.day.toString(); // no padding
      return "$y-$m-$d";
    }

    const weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    final today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      final dateKey = formatDate(date);
      final dayName = weekdays[date.weekday - 1];

      // Read list from Hive using date key
      final List habitsForDay = (habitsBox.get(dateKey)) ?? [];

      // Count completed habits
      final completedCount = habitsForDay
          .where((habit) => habit.isHabitCompleted)
          .length;

      result[dayName] = {
        "date": dateKey,
        "numberOfCompletions": completedCount,
      };
    }

    return result;
  }

  //* Weekly (Current Week Habits Completion Count (Monday --> Sunday))
  Map<String, Map<String, dynamic>> getCurrentWeekHabitCompletion({
    required Box habitsBox,
  }) {
    final Map<String, Map<String, dynamic>> result = {};

    // yyyy-MM-dd formatter
    String formatDate(DateTime date) {
      final y = date.year.toString();
      final m = date.month.toString(); // no padding
      final d = date.day.toString(); // no padding
      return "$y-$m-$d";
    }

    const weekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    final today = DateTime.now();

    // 🔹 Find Monday of the current week
    final monday = today.subtract(Duration(days: today.weekday - 1));

    // 🔹 Loop from Monday → Sunday
    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final dateKey = formatDate(date);
      final dayName = weekdays[date.weekday - 1];

      // Read list from Hive using date key
      final List habitsForDay = habitsBox.get(dateKey) ?? [];

      // Count completed habits
      final completedCount = habitsForDay
          .where((habit) => habit.isHabitCompleted)
          .length;

      result[dayName] = {
        "date": dateKey,
        "numberOfCompletions": completedCount,
      };
    }

    return result;
  }

  //* Monthly (Past 28 Days Including today --> Habit Completion Count)
  Map<String, Map<String, dynamic>> getLast28DaysHabitCompletion({
    required Box habitsBox,
  }) {
    final Map<String, Map<String, dynamic>> result = {};

    String formatDate(DateTime date) {
      final y = date.year.toString();
      final m = date.month.toString(); // no padding
      final d = date.day.toString(); // no padding
      return "$y-$m-$d";
    }

    final today = DateTime.now();
    int availableDatesCount = 0;

    for (int i = 0; i < 28; i++) {
      final date = today.subtract(Duration(days: i));
      final dateKey = formatDate(date);

      // ✅ Check if date exists in Hive
      final bool hasDate = habitsBox.containsKey(dateKey);
      if (hasDate) {
        availableDatesCount++;
      }

      final List habitsForDay = habitsBox.get(dateKey) ?? [];

      final completedCount = habitsForDay
          .where((habit) => habit.isHabitCompleted)
          .length;

      result[dateKey] = {
        "date": dateKey,
        "numberOfCompletions": completedCount,
      };
    }

    // 🔴 Condition based on AVAILABLE DATES
    if (availableDatesCount <= 15) {
      return {};
    }

    return result;
  }

  //* Monthly (Current Month – First 28 Days Habit Completion)
  Map<String, Map<String, dynamic>> getCurrentMonth28DaysHabitCompletion({
    required Box habitsBox,
  }) {
    final Map<String, Map<String, dynamic>> result = {};

    String formatDate(DateTime date) {
      final y = date.year.toString();
      final m = date.month.toString(); // no padding
      final d = date.day.toString(); // no padding
      return "$y-$m-$d";
    }

    final today = DateTime.now();
    final firstDayOfMonth = DateTime(today.year, today.month, 1);

    int availableDatesCount = 0;

    for (int i = 0; i < 28; i++) {
      final date = firstDayOfMonth.add(Duration(days: i));
      final dateKey = formatDate(date);

      // ✅ Check if date exists in Hive
      final bool hasDate = habitsBox.containsKey(dateKey);
      if (hasDate) {
        availableDatesCount++;
      }

      final List habitsForDay = habitsBox.get(dateKey) ?? [];

      final completedCount = habitsForDay
          .where((habit) => habit.isHabitCompleted)
          .length;

      result[dateKey] = {
        "date": dateKey,
        "numberOfCompletions": completedCount,
      };
    }

    // 🔴 Condition based on AVAILABLE DATES
    if (availableDatesCount <= 15) {
      return {};
    }

    return result;
  }

  //Straks
  Map<String, int> getCompletionsPerDate({required Box habitsBox}) {
    final Map<String, int> result = {};

    for (final key in habitsBox.keys) {
      if (key is! String) continue;

      final List habitsForDay = habitsBox.get(key) ?? [];

      final int completedCount = habitsForDay
          .where((habit) => habit.isHabitCompleted)
          .length;

      result[key] = completedCount;
    }

    return result;
  }
}
