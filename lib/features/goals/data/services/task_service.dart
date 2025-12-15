import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:life_goal/features/goals/data/models/habits_values_model.dart';
import 'package:life_goal/features/goals/data/models/tasks_model.dart';

class TaskService {
  TaskService._internal();
  static final _singleton = TaskService._internal();

  factory TaskService() {
    return _singleton;
  }

  final Box<TasksModel> _userBox = Hive.box<TasksModel>('tasks');
  final Box<HabitModel> _habitBox = Hive.box<HabitModel>(
    HiveConstants.habitsBox,
  );

  Future<void> addTask(TasksModel task) async {
    final key = task.taskKey;
    await _userBox.put(key, task);
  }

  Future<void> addNewHabit(HabitModel habit) async {
    final key = habit.habitKey;
    await _habitBox.put(key, habit);
  }

  Future<void> saveTotalHabitHabit() async {
    final int totalHabitCount = _habitBox.values.length;
    await Hive.box(
      HiveConstants.unitValuesBox,
    ).put(HiveConstants.totalHabitCount, totalHabitCount);
  }

  Future<void> incrementPoints(int points) async {
    final pointsBox = Hive.box(HiveConstants.userPointsBox);
    final int totalPoints = await pointsBox.get(HiveConstants.totalPoints) ?? 0;
    await pointsBox.put(HiveConstants.totalPoints, totalPoints + points);
  }

  Future<void> updateTask(TasksModel task) async {
    final key = task.taskKey;
    await _userBox.put(key, task);
  }

  Future<void> deleteTask(String key) async {
    await _userBox.delete(key);
  }

  List<TasksModel> getAllTasks() {
    return _userBox.values.toList();
  }

  // Save Pending tasks Count
  Future<void> savePendingTasksCount() async {
    final List<TasksModel> allTasks = Hive.box<TasksModel>(
      HiveConstants.tasksBox,
    ).values.toList();
    final int pendingTasksLenght = allTasks.length;
    await Hive.box(
      HiveConstants.unitValuesBox,
    ).put(HiveConstants.pendingTaskCount, pendingTasksLenght);
  }

  // Save Completed tasks Count
  Future<void> saveCompletedTasksCount() async {
    final List<TasksModel> allTasks = Hive.box<TasksModel>(
      HiveConstants.tasksBox,
    ).values.toList();
    final int completedTasksLenght = allTasks
        .where((task) {
          return task.isTaskDone;
        })
        .toList()
        .length;
    await Hive.box(
      HiveConstants.unitValuesBox,
    ).put(HiveConstants.completedTaskCount, completedTasksLenght);
  }

  Future<void> updateTodaysCount(Box<dynamic> valueBox) async {
    DateTime date = DateTime.now();

    // Format year & month with DateFormat
    String ym = DateFormat('yyyy-MM').format(date);

    // Add day manually without leading zero
    String dateNow = "$ym-${date.day}";
    final allTodayValues = valueBox.get(dateNow) ?? [];
    final totalCompletedCount = allTodayValues.where((eachModel) {
      return eachModel.isHabitCompleted == true;
    }).toList();
    final count = totalCompletedCount.length;
    log('The Completed Count: $count');
    await Hive.box(
      HiveConstants.unitValuesBox,
    ).put(HiveConstants.todaysHabitCompleted, count);
  }

  //* Two Types of Habits
  //1- Binary (Tap to complete and Tap Again to Undo)
  //2- Custom (Increment or decrement the values to reach the target value
  // and when the target is achieved then the habit is completed).

  //? How to know int the code that wether it is Binary or Custom?
  //  if the value of habitValue.habitValue = 0 the its Binary Habit
  //  if the value of habitValue.habitValue = 1 the its Custom Habit

  //? Function for Binary Habit Completion
  //? This function is for weekly view only because you can complete the habits of all the week by tapping the blocks
  Future<void> completeHabit(
    HabitModel habit,
    HabitsValuesModel habitValue,
    List allValues,
    String dateKey,
    Box<dynamic> valueBox,
  ) async {
    if (habitValue.habitVlaue == 0) {
      allValues.add(
        HabitsValuesModel(
          habitKey: habit.key,
          habitVlaue: 1,
          isHabitCompleted: true,
        ),
      );
      // Save the List in the box
      await Hive.box(
        HiveConstants.habitValueBox,
      ).put(dateKey, allValues).whenComplete(() async {
        await incrementPoints(15);
        updateTodaysCount(valueBox);
      });
    } else {
      allValues.removeWhere((theHabit) {
        return theHabit.habitKey == habit.habitKey;
      });
      // Save the List in the box
      await Hive.box(
        HiveConstants.habitValueBox,
      ).put(dateKey, allValues).whenComplete(() async {
        await incrementPoints(-15);
        updateTodaysCount(valueBox);
      });
    }
  }

  //? we can only complete the current day Habit.
  //? This  for Monthly and Yearly View

  Future<void> completeTodayHabit(
    HabitModel habit,
    HabitsValuesModel habitValue,
    String dateToday,
    List todaysValueBox,
    Box<dynamic> valueBox,
  ) async {
    log('Value Count is Zero');
    if (habitValue.habitVlaue == 0) {
      todaysValueBox.add(
        HabitsValuesModel(
          habitKey: habit.key,
          habitVlaue: 1,
          isHabitCompleted: true,
        ),
      );
      await Hive.box(
        HiveConstants.habitValueBox,
      ).put(dateToday, todaysValueBox).whenComplete(() async {
        await incrementPoints(15);
        updateTodaysCount(valueBox);
      });
    } else {
      todaysValueBox.removeWhere((theHabit) {
        return theHabit.habitKey == habit.habitKey;
      });
      await Hive.box(
        HiveConstants.habitValueBox,
      ).put(dateToday, todaysValueBox).whenComplete(() async {
        await incrementPoints(15);
        updateTodaysCount(valueBox);
      });
    }
  }

  //?Custom Habit Value Completion Functions
  Future<void> incrementCustomHabit(
    HabitsValuesModel habitValue,
    HabitModel habit,
    List allValues,
    String specificDate,
    Box<dynamic> valueBox,
  ) async {
    if (habitValue.habitVlaue < habit.valueCount) {
      int value = habitValue.habitVlaue + 1;

      final index = allValues.indexWhere((item) => item.habitKey == habit.key);

      if (index == -1) {
        log('Habit Value: ${habitValue.habitVlaue}');
        log('Habit Value: ${habit.valueCount}');
        // Not found — add
        allValues.add(
          HabitsValuesModel(
            habitKey: habit.key,
            habitVlaue: value,
            isHabitCompleted: (habitValue.habitVlaue + 1) == habit.valueCount,
          ),
        );
      } else {
        // Found — update
        allValues[index] = HabitsValuesModel(
          habitKey: habit.key,
          habitVlaue: value,
          isHabitCompleted: (habitValue.habitVlaue + 1) == habit.valueCount,
        );
      }

      await Hive.box(
        HiveConstants.habitValueBox,
      ).put(specificDate, allValues).whenComplete(() async {
        updateTodaysCount(valueBox);
        if ((habitValue.habitVlaue + 1) == habit.valueCount) {
          await incrementPoints(15);
        }
      });
    }
  }

  Future<void> decrementCustomHabit(
    HabitsValuesModel habitValue,
    HabitModel habit,
    List allValues,
    String specificDate,
    Box<dynamic> valueBox,
  ) async {
    if (habitValue.habitVlaue != 0) {
      int value = habitValue.habitVlaue - 1;
      // In the upper line the 1 is being subtracted from habit value
      // because it already has 1 which shows the type of habit (custom)
      // Now to reset it to zero 1 is subtracted.

      final index = allValues.indexWhere((item) => item.habitKey == habit.key);

      if (index == -1) {
      } else {
        if ((habitValue.habitVlaue) == habit.valueCount) {
          await incrementPoints(-15);
        }
        // Found — update
        allValues[index] = HabitsValuesModel(
          habitKey: habit.key,
          habitVlaue: value,
          isHabitCompleted: (habitValue.habitVlaue + 1) == habit.valueCount,
        );
      }

      await Hive.box(
        HiveConstants.habitValueBox,
      ).put(specificDate, allValues).whenComplete(() async {
        updateTodaysCount(valueBox);
      });
    }
  }

  Future<void> resetCustomHabit(
    HabitsValuesModel habitValue,
    HabitModel habit,
    List allValues,
    String specificDate,
    Box<dynamic> valueBox,
  ) async {
    if (habitValue.habitVlaue > 0) {
      final index = allValues.indexWhere((item) => item.habitKey == habit.key);

      if (index == -1) {
        // Not found — add
        allValues.add(
          HabitsValuesModel(
            habitKey: habit.key,
            habitVlaue: 0,
            isHabitCompleted: false,
          ),
        );
      } else {
        // Found — update
        allValues[index] = HabitsValuesModel(
          habitKey: habit.key,
          habitVlaue: 0,
          isHabitCompleted: false,
        );
      }

      await Hive.box(
        HiveConstants.habitValueBox,
      ).put(specificDate, allValues).whenComplete(() async {
        updateTodaysCount(valueBox);
        if (habitValue.habitVlaue == habit.valueCount) {
          await incrementPoints(-15);
        }
      });
    }
  }

  Future<void> fillCustomHabit(
    HabitsValuesModel habitValue,
    HabitModel habit,
    List allValues,
    String specificDate,
    Box<dynamic> valueBox,
  ) async {
    if (habitValue.habitVlaue != habit.valueCount) {
      final index = allValues.indexWhere((item) => item.habitKey == habit.key);

      if (index == -1) {
        // Not found — add
        allValues.add(
          HabitsValuesModel(
            habitKey: habit.key,
            habitVlaue: habit.valueCount,
            isHabitCompleted: true,
          ),
        );
      } else {
        // Found — update
        allValues[index] = HabitsValuesModel(
          habitKey: habit.key,
          habitVlaue: habit.valueCount,
          isHabitCompleted: true,
        );
      }

      await Hive.box(
        HiveConstants.habitValueBox,
      ).put(specificDate, allValues).whenComplete(() async {
        updateTodaysCount(valueBox);
        if (habitValue.habitVlaue == habit.valueCount) {
        } else {
          await incrementPoints(15);
        }
      });
    }
  }
}
