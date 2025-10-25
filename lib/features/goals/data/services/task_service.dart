import 'package:hive/hive.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
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

  // TasksModel? getTask(int index) {
  //   return _userBox.getAt(index);
  // }

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
}
