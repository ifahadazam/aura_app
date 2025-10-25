import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_goal/config/routes/app_routes.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/Main/presentation/bloc/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:life_goal/features/goals/data/models/habits_values_model.dart';
import 'package:life_goal/features/goals/data/models/tasks_model.dart';
import 'package:life_goal/features/goals/presentation/bloc/get_daily_reminder_bloc/get_daily_reminder_bloc.dart';
import 'package:life_goal/features/goals/presentation/bloc/get_selected_task_priority_bloc/get_selected_task_priority_bloc.dart';
import 'package:life_goal/features/goals/presentation/bloc/get_streak_goal_bloc/get_streak_goal_bloc.dart';
import 'package:life_goal/features/goals/presentation/bloc/habit_view_bloc/habit_view_bloc.dart';
import 'package:life_goal/features/goals/presentation/bloc/search_tasks_bloc/search_tasks_bloc.dart';
import 'package:life_goal/features/goals/presentation/bloc/select_reminder_time_bloc/select_reminder_time_bloc.dart';
import 'package:life_goal/features/goals/presentation/bloc/show_search_task_bar_bloc/show_search_task_bar_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TasksModelAdapter());
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(HabitsValuesModelAdapter());
  await Hive.openBox<TasksModel>(HiveConstants.tasksBox);
  await Hive.openBox(HiveConstants.habitValueBox);
  await Hive.openBox<HabitModel>(HiveConstants.habitsBox);
  await Hive.openBox(HiveConstants.unitValuesBox);
  await Hive.openBox(HiveConstants.habitReminderBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomBarBloc()),
        BlocProvider(create: (_) => ShowSearchTaskBarBloc()),
        BlocProvider(create: (_) => SearchTasksBloc()),
        BlocProvider(create: (_) => SelectReminderTimeBloc()),
        BlocProvider(create: (_) => GetStreakGoalBloc()),
        BlocProvider(create: (_) => GetDailyReminderBloc()),
        BlocProvider(create: (_) => GetSelectedTaskPriorityBloc()),
        BlocProvider(create: (_) => HabitViewBloc()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRoutes.appRouter,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor:
                  AppColors.transparentColor, // Status bar background
              statusBarIconBrightness:
                  Brightness.dark, // Make status bar icons black
              //  statusBarBrightness: Brightness.light, // For iOS
            ),
          ),
        ),
      ),
    );
  }
}
