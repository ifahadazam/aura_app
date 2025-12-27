import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:life_goal/config/routes/app_route_constants.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/Home/presentation/widgets/calender_widget.dart';
import 'package:life_goal/features/Home/presentation/widgets/circular_graph.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:life_goal/features/goals/data/services/habit_stats_service.dart';

String userLevel(int totalPoints) {
  if (totalPoints >= 0 && totalPoints < l1) {
    return 'Rookie';
  } else if (totalPoints >= l1 && totalPoints < l2) {
    return 'Unstoppable';
  } else if (totalPoints >= l2 && totalPoints < l3) {
    return 'Pro+';
  } else if (totalPoints >= l3 && totalPoints < l4) {
    return 'Mastermind';
  } else if (totalPoints >= l4 && totalPoints < l5) {
    return 'Genius';
  } else if (totalPoints >= l5 && totalPoints < l6) {
    return 'Sigma';
  } else if (totalPoints >= l6 && totalPoints < l7) {
    return 'Aura Activated';
  } else if (totalPoints >= l7 && totalPoints < l8) {
    return 'Cosmic Aura';
  } else {
    return 'Infinite Aura';
  }
}

Map<String, dynamic> levelPercentage(int points) {
  final currentLevel = userLevel(points);
  final nextLevelName = pointsAndLevels[currentLevel]['next'];
  final nextLevelPoints = pointsAndLevels[nextLevelName]['points'];

  //final int nextLevelPoints = pointsAndLevels['l$nextLevel']['points'];
  final percentage = (points / nextLevelPoints);
  //final nextLevelName = pointsAndLevels['l$nextLevel']['level'];
  return {'percentage': percentage, 'nextLevel': nextLevelName};
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: AppConstants.pagesInternalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CalenderWidget(),
            AppConstants.defaultSpace,
            FutureGoalWidget(),
            AppConstants.defaultSpace,
            ValueListenableBuilder(
              valueListenable: Hive.box(
                HiveConstants.userPointsBox,
              ).listenable(),
              builder: (context, pointsBox, child) {
                final int totalPoints =
                    pointsBox.get(HiveConstants.totalPoints) ?? 0;
                final String level = userLevel(totalPoints);
                final String nextLevel = levelPercentage(
                  totalPoints,
                )['nextLevel'];
                final percentage =
                    ((levelPercentage(totalPoints)['percentage']) * 100)
                        .toStringAsFixed(1);
                return Container(
                  width: double.maxFinite,
                  // height: 130,
                  padding: AppConstants.widgetInternalPadding,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGreyColor),
                    color: AppColors.themeWhite,
                    borderRadius: AppConstants.widgetBorderRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius:
                                  AppConstants.widgetMediumBorderRadius,
                            ),
                            child: Center(
                              child: Icon(
                                HugeIcons.strokeRoundedMedal02,
                                color: AppColors.themeBlack,
                                size: 22,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                textAlign: TextAlign.start,
                                '$level ',
                                style: TypographyTheme.simpleSubTitleStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.start,
                                '$totalPoints ',
                                style: TypographyTheme.simpleTitleStyle(
                                  fontSize: 19,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      AppConstants.defaultSpace,
                      Text(
                        textAlign: TextAlign.start,
                        '$percentage% closer to $nextLevel',
                        style: TypographyTheme.simpleSubTitleStyle(
                          fontSize: 12,
                        ),
                      ),
                      AppConstants.defaultSpace,

                      Container(
                        height: 6,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: AppColors.xtraLightGreyColor,
                          borderRadius: AppConstants.widgetBorderRadius,
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          heightFactor: 1,
                          widthFactor: levelPercentage(
                            totalPoints,
                          )['percentage'],
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: AppConstants.widgetBorderRadius,
                              color: AppColors.themeBlack,
                            ),
                          ),
                        ),
                      ),
                      AppConstants.defaultSpace,
                    ],
                  ),
                );
              },
            ),

            AppConstants.defaultSpace,
            HabitsNGoalsWidget(),

            AppConstants.defaultSpace,
            Text(
              '  Today',
              style: TypographyTheme.simpleTitleStyle(fontSize: 13),
            ),
            AppConstants.defaultSpace,

            ValueListenableBuilder(
              valueListenable: Hive.box(
                HiveConstants.unitValuesBox,
              ).listenable(),
              builder: (context, pendingCountBox, _) {
                final int pendingTasksCount =
                    pendingCountBox.get(HiveConstants.pendingTaskCount) ?? 0;
                final int completedTasksCount =
                    pendingCountBox.get(HiveConstants.completedTaskCount) ?? 0;
                final int pendingTasks =
                    pendingTasksCount - completedTasksCount;
                final habitCount =
                    pendingCountBox.get(HiveConstants.totalHabitCount) ?? 0;

                final int completedHabitsToday =
                    pendingCountBox.get(HiveConstants.todaysHabitCompleted) ??
                    0;
                final int pendingHabitsToday =
                    habitCount - completedHabitsToday;

                //  final int pendingHabitsToday = 0;

                return pendingHabitsToday == 0 && pendingTasks == 0
                    ? Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.xtraLightGreyColor,
                          borderRadius: AppConstants.widgetBorderRadius,
                        ),
                        child: Center(
                          child: Text(
                            'No Pending Tasks & Habits to \n complete Today!',
                            textAlign: TextAlign.center,
                            style: TypographyTheme.simpleSubTitleStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          if (pendingTasks != 0)
                            InkWell(
                              onTap: () {
                                context.pushNamed(RouteConstants.tasksPageName);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                padding: AppConstants.widgetInternalPadding,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.lightGreyColor,
                                  ),
                                  color: AppColors.themeWhite,
                                  borderRadius: AppConstants.widgetBorderRadius,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: AppConstants
                                            .widgetMediumBorderRadius,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          HugeIcons.strokeRoundedTarget02,
                                          color: AppColors.themeBlack,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                    AppConstants.singleWidth,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'You have $pendingTasks tasks pending',
                                            style:
                                                TypographyTheme.simpleTitleStyle(
                                                  fontSize: 14,
                                                ),
                                          ),

                                          Text(
                                            textAlign: TextAlign.center,
                                            'Take Action..',
                                            style:
                                                TypographyTheme.simpleSubTitleStyle(
                                                  fontSize: 13,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.themeBlack,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          AppConstants.defaultSpace,
                          if (pendingHabitsToday != 0)
                            InkWell(
                              onTap: () {
                                context.pushNamed(
                                  RouteConstants.goodHabitsPageName,
                                );
                              },
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                padding: AppConstants.widgetInternalPadding,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.lightGreyColor,
                                  ),
                                  color: AppColors.themeWhite,
                                  borderRadius: AppConstants.widgetBorderRadius,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: AppConstants
                                            .widgetMediumBorderRadius,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          HugeIcons.strokeRoundedMedal05,
                                          color: AppColors.themeBlack,
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                    AppConstants.singleWidth,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$pendingHabitsToday Habits Needs Action',
                                            style:
                                                TypographyTheme.simpleTitleStyle(
                                                  fontSize: 14,
                                                ),
                                          ),

                                          Text(
                                            textAlign: TextAlign.center,
                                            'Get Started Now',
                                            style:
                                                TypographyTheme.simpleSubTitleStyle(
                                                  fontSize: 13,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.themeBlack,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HabitsNGoalsWidget extends StatelessWidget {
  const HabitsNGoalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                context.pushNamed(RouteConstants.goodHabitsPageName);
              },
              child: ValueListenableBuilder(
                valueListenable: Hive.box(
                  HiveConstants.unitValuesBox,
                ).listenable(),

                builder: (context, unitBox, child) {
                  final totalHabitCount =
                      unitBox.get(HiveConstants.totalHabitCount) ?? 0;
                  final completedHabitsToday =
                      unitBox.get(HiveConstants.todaysHabitCompleted) ?? 0;
                  final double habitCompletedPercentage =
                      completedHabitsToday / totalHabitCount;
                  return Container(
                    height: double.maxFinite,
                    padding: EdgeInsets.all(AppConstants.kMediumPadding),
                    decoration: BoxDecoration(
                      borderRadius: AppConstants.widgetBorderRadius,
                      color: AppColors.themeWhite,
                      border: Border.all(color: AppColors.lightGreyColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              textAlign: TextAlign.start,
                              '$completedHabitsToday/$totalHabitCount',
                              style: TypographyTheme.simpleTitleStyle(
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.arrow_outward_sharp,
                              color: AppColors.themeBlack,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          textAlign: TextAlign.start,
                          'Habits',
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 13,
                          ),
                        ),
                        AppConstants.defaultSpace,
                        totalHabitCount == 0
                            ? CircularGraph(
                                completedValue: 0.0,
                                iconData: Icons.grid_view_rounded,
                              )
                            : CircularGraph(
                                completedValue: habitCompletedPercentage,
                                iconData: Icons.grid_view_rounded,
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          AppConstants.singleWidth,
          Expanded(
            child: InkWell(
              onTap: () {
                context.pushNamed(RouteConstants.tasksPageName);
              },
              child: ValueListenableBuilder(
                valueListenable: Hive.box(
                  HiveConstants.unitValuesBox,
                ).listenable(),
                builder: (context, pendingCountBox, child) {
                  final pendingTasksCount =
                      pendingCountBox.get(HiveConstants.pendingTaskCount) ?? 0;
                  final completedTasksCount =
                      pendingCountBox.get(HiveConstants.completedTaskCount) ??
                      0;

                  final double completedTaskPercentage =
                      completedTasksCount / pendingTasksCount;

                  return Container(
                    height: double.maxFinite,
                    padding: EdgeInsets.all(AppConstants.kMediumPadding),
                    decoration: BoxDecoration(
                      borderRadius: AppConstants.widgetBorderRadius,
                      color: AppColors.themeWhite,
                      border: Border.all(color: AppColors.lightGreyColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              textAlign: TextAlign.start,
                              '$completedTasksCount/$pendingTasksCount',
                              style: TypographyTheme.simpleTitleStyle(
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.arrow_outward_sharp,
                              color: AppColors.themeBlack,
                              size: 16,
                            ),
                          ],
                        ),

                        Text(
                          textAlign: TextAlign.start,
                          'Goals',
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 13,
                          ),
                        ),
                        AppConstants.defaultSpace,
                        pendingTasksCount == 0
                            ? CircularGraph(
                                completedValue: 0.0,
                                iconData: CupertinoIcons.doc,
                              )
                            : CircularGraph(
                                completedValue: completedTaskPercentage,
                                iconData: CupertinoIcons.doc,
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          AppConstants.singleWidth,
          ValueListenableBuilder(
            valueListenable: Hive.box<HabitModel>(
              HiveConstants.habitsBox,
            ).listenable(),
            builder: (context, allHabits, child) {
              final habits = allHabits.values.toList();
              int maxCurrentStreak = allHabits.isEmpty
                  ? 0
                  : habits
                        .map((h) => h.currentStreak!)
                        .reduce((a, b) => a > b ? a : b);
              int maxBestStreak = allHabits.isEmpty
                  ? 0
                  : habits
                        .map((h) => h.bestStreak!)
                        .reduce((a, b) => a > b ? a : b);

              List<int> result = List.generate(
                40,
                (index) => index < maxBestStreak ? 1 : 0,
              );
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      builder: (context) => Wrap(
                        children: [
                          VerticalStreakSheet(
                            bestStreak: maxBestStreak,
                            currentStreak: maxCurrentStreak,
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: double.maxFinite,
                    padding: EdgeInsets.all(AppConstants.kMediumPadding),
                    decoration: BoxDecoration(
                      borderRadius: AppConstants.widgetBorderRadius,
                      color: AppColors.themeWhite,
                      border: Border.all(color: AppColors.lightGreyColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              textAlign: TextAlign.start,
                              maxBestStreak.toString(),
                              style: TypographyTheme.simpleTitleStyle(
                                fontSize: 16,
                              ),
                            ),
                            Icon(
                              Icons.arrow_outward_sharp,
                              color: AppColors.themeBlack,
                              size: 16,
                            ),
                          ],
                        ),

                        Text(
                          textAlign: TextAlign.start,
                          'Streak',
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 13,
                          ),
                        ),
                        AppConstants.defaultSpace,
                        SizedBox(
                          width: double.maxFinite,
                          height: 60,
                          child: GridView.builder(
                            itemCount: result.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 3,
                                ),

                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: result[index] == 1
                                      ? AppColors.themeBlack
                                      : AppColors.lightGreyColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FutureGoalWidget extends StatelessWidget {
  const FutureGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: AppConstants.widgetInternalPadding,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGreyColor),
        color: AppColors.themeWhite,
        borderRadius: AppConstants.widgetBorderRadius,
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: AppConstants.widgetMediumBorderRadius,
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.rocket_fill,
                color: AppColors.themeBlack,
                size: 22,
              ),
            ),
          ),
          AppConstants.singleWidth,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                valueListenable: Hive.box(
                  HiveConstants.futureGoalBox,
                ).listenable(),
                builder: (context, box, child) {
                  final futureGoal =
                      box.get(HiveConstants.futureGoalBoxValue) ?? '---------';
                  return Text(
                    textAlign: TextAlign.center,
                    '"I am $futureGoal"',
                    style: TypographyTheme.simpleTitleStyle(
                      fontSize: 15,
                    ).copyWith(fontStyle: FontStyle.italic),
                  );
                },
              ),
              Text(
                '~ Future Me',
                style: TypographyTheme.simpleSubTitleStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String dateTimeToString(DateTime date) {
  final year = date.year.toString();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return "$year-$month-$day";
}

class VerticalStreakSheet extends StatelessWidget {
  const VerticalStreakSheet({
    super.key,
    required this.bestStreak,
    required this.currentStreak,
  });
  final int bestStreak;
  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final habitStats = HabitStatsService();
    int year = DateTime.now().year;

    /// Generate ALL days of the year continuously
    List<DateTime> allDays = [];
    for (int m = 1; m <= 12; m++) {
      int days = DateUtils.getDaysInMonth(year, m);
      for (int d = 1; d <= days; d++) {
        allDays.add(DateTime(year, m, d));
      }
    }

    List<String> monthNames = List.generate(
      12,
      (i) => DateFormat.MMM().format(DateTime(year, i + 1)),
    );

    // Color getColor(DateTime date) {
    //   switch (date.day % 4) {
    //     case 1:
    //       return Colors.grey.shade600;
    //     case 2:
    //       return Colors.grey.shade800;
    //     case 3:
    //       return Colors.black;
    //     default:
    //       return Colors.grey.shade300;
    //   }
    // }

    /// Split entire year into rows of 15 blocks
    List<List<DateTime>> rows = [];
    for (int i = 0; i < allDays.length; i += 15) {
      rows.add(allDays.skip(i).take(15).toList());
    }
    double blocksHeight = rows.length * (12 + 3); // block height + margin

    return Padding(
      padding: EdgeInsetsGeometry.all(AppConstants.kLargePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppConstants.defaultDoubleSpace,
          Text(
            currentStreak.toString(),
            style: TypographyTheme.simpleTitleStyle(
              fontSize: 50,
            ).copyWith(height: 1),
          ),
          Text(
            'Current Streak',
            style: TypographyTheme.simpleTitleStyle(fontSize: 18),
          ),

          Text(
            'You are doing great work.',
            style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
          ),

          AppConstants.defaultDoubleSpace,
          AppConstants.defaultDoubleSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT SIDE: MONTH LABELS
              SizedBox(
                height: blocksHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: monthNames
                      .map(
                        (month) => Text(
                          month,
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 13,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              // AppConstants.doubleWidth,

              /// RIGHT SIDE: ALL DAYS BLOCKS
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box(
                    HiveConstants.habitValueBox,
                  ).listenable(),
                  builder: (context, habitValues, child) {
                    return ValueListenableBuilder(
                      valueListenable: Hive.box(
                        HiveConstants.unitValuesBox,
                      ).listenable(),
                      builder: (context, unitValues, child) {
                        final totalHaitCount =
                            unitValues.get(HiveConstants.totalHabitCount) ?? 0;
                        final habitCompletionPerDate = habitStats
                            .getCompletionsPerDate(habitsBox: habitValues);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: rows.map((row) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: row.map((date) {
                                final dateKey = dateTimeToString(date);
                                final completionCount =
                                    habitCompletionPerDate[dateKey] ?? 0;
                                final colorValue =
                                    completionCount / totalHaitCount;
                                final colorIntensity = colorValue * 255;
                                return Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsets.only(
                                    right: 3,
                                    bottom: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: completionCount > 0
                                        ? AppColors.themeBlack.withAlpha(
                                            colorIntensity.toInt(),
                                          )
                                        : AppColors.themeBlack.withAlpha(50),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
