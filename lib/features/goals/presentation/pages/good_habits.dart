import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:life_goal/config/routes/app_route_constants.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/extensions/sized_box.dart';
import 'package:life_goal/core/shared/buttons/icon_tap_button.dart';
import 'package:life_goal/core/shared/internal_page_app_bar.dart';
import 'package:life_goal/core/shared/new_leveL_unlock_popup.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:intl/intl.dart';
import 'package:life_goal/features/goals/data/models/habits_values_model.dart';
import 'package:life_goal/features/goals/data/services/habit_stats_service.dart';
import 'package:life_goal/features/goals/data/services/task_service.dart';
import 'package:life_goal/features/goals/presentation/bloc/habit_view_bloc/habit_view_bloc.dart';
import 'package:life_goal/features/goals/presentation/pages/create_habit.dart';
import 'package:table_calendar/table_calendar.dart';

const weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

final months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

final totalWeeks = 53; // 52–53 weeks in a year

List<String> getCurrentMonthDateStrings() {
  final now = DateTime.now();

  final end = DateTime(now.year, now.month + 1, 0);

  final formatter = DateFormat('y-M-d');

  return List.generate(end.day, (i) {
    final date = DateTime(now.year, now.month, i + 1);
    return formatter.format(date);
  });
}

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');

  if (hex.length == 6) {
    // If format is RRGGBB, assume full opacity
    hex = 'FF$hex';
  }

  if (hex.length != 8) {
    // throw FormatException("Invalid HEX color format.");
  }

  final a = int.parse(hex.substring(0, 2), radix: 16);
  final r = int.parse(hex.substring(2, 4), radix: 16);
  final g = int.parse(hex.substring(4, 6), radix: 16);
  final b = int.parse(hex.substring(6, 8), radix: 16);

  return Color.fromARGB(a, r, g, b);
}

List<DateTime> getDatesFromNowToEndOfYear() {
  final now = DateTime.now();
  final end = DateTime(now.year, 12, 31);
  final totalDays = end.difference(now).inDays + 1;
  return List.generate(totalDays, (i) => now.add(Duration(days: i)));
}

/// Generates all dates from 1st of current month to end of year
List<DateTime> getDatesFromFirstOfMonthToEndOfYear() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, 12, 31);
  final totalDays = end.difference(start).inDays + 1;
  return List.generate(totalDays, (i) => start.add(Duration(days: i)));
}

/// Pads the list so the first date appears in the correct weekday slot
List<DateTime?> generatePaddedDates() {
  final dates = getDatesFromFirstOfMonthToEndOfYear();
  final firstDate = dates.first;

  // Sunday = 0, Monday = 1, ..., Saturday = 6
  final paddingCount = firstDate.weekday % 7;

  final paddedList = List<DateTime?>.filled(paddingCount, null, growable: true);
  paddedList.addAll(dates);

  return paddedList;
}

List<String> getCurrentWeekDatesAsStrings() {
  final today = DateTime.now();
  final currentWeekday = today.weekday;

  final monday = today.subtract(Duration(days: currentWeekday - 1));

  final formatter = DateFormat('y-M-d'); // e.g. 2025-7-8

  return List.generate(7, (index) {
    final date = monday.add(Duration(days: index));
    return formatter.format(date);
  });
}

int todayIndex() {
  final today = DateTime.now();
  return today.weekday - 1; // Monday (1) → 0, ..., Sunday (7) → 6
}

int colorAlphaValue(int valueCount, int habitVlaue) {
  final double colorIntensity = habitVlaue / valueCount;
  if (valueCount == 0) {
    return habitVlaue == 1 ? 255 : 40;
  } else {
    return ((colorIntensity * 215) + 40).toInt();
  }
}

class GoodHabits extends StatelessWidget {
  const GoodHabits({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamyWhiteColor,
      appBar: InternalPageAppBar(
        title: 'Habits',
        themeColor: AppColors.themeBlack,
        actions: [
          IconTapButton(
            onTap: () {
              context.pushNamed(RouteConstants.newHabitPageName);
            },
            iconDta: Icons.add,
            iconColor: AppColors.themeBlack,
            iconSize: 24,
          ),
          AppConstants.singleWidth,
        ],
      ),
      body: Padding(
        padding: AppConstants.pagesInternalPadding,
        child: ValueListenableBuilder(
          valueListenable: Hive.box<HabitModel>(
            HiveConstants.habitsBox,
          ).listenable(),
          builder: (context, allHabitsBox, child) {
            final List<HabitModel> allHabits = allHabitsBox.values.toList();

            return allHabits.isEmpty
                ? Center(
                    child: Text(
                      'No Habits, Please add One',
                      style: TypographyTheme.simpleTitleStyle(fontSize: 14),
                    ),
                  )
                : Column(
                    children: [
                      BlocBuilder<HabitViewBloc, HabitViewState>(
                        builder: (context, state) {
                          return state.viewTag == 'weekly'
                              ? Container(
                                  padding: AppConstants.widgetInternalPadding,
                                  height: 42,
                                  width: double.maxFinite,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox.shrink(),
                                      Row(
                                        spacing: 8,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,

                                        children: List.generate(weekDays.length, (
                                          index,
                                        ) {
                                          final bool isToday =
                                              todayIndex() == index;
                                          return Column(
                                            children: [
                                              Text(
                                                weekDays[index],
                                                style: isToday
                                                    ? TypographyTheme.simpleTitleStyle(
                                                        fontSize: 11,
                                                      )
                                                    : TypographyTheme.simpleSubTitleStyle(
                                                        fontSize: 11,
                                                      ),
                                              ),

                                              SizedBox(height: 1, width: 25),
                                              ColoredBox(
                                                color: isToday
                                                    ? AppColors.themeBlack
                                                    : AppColors.greyColor,
                                                child: SizedBox(
                                                  height: 6,
                                                  width: 1,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink();
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: allHabits.length,
                          itemBuilder: (context, index) {
                            final HabitModel eachHbait = allHabits[index];

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: AppConstants.kSmallPadding,
                              ),
                              child: BlocBuilder<HabitViewBloc, HabitViewState>(
                                builder: (context, state) {
                                  final view = state.viewTag;
                                  if (view == 'weekly') {
                                    return WeeklyHabitStreak(
                                      habit: eachHbait,
                                      allHabitsBox: allHabitsBox,
                                    );
                                  } else if (view == 'monthly') {
                                    return MonthlyStreak(habit: eachHbait);
                                  } else {
                                    return YearlyHabitStreak(habit: eachHbait);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: AppColors.transparentColor,
        height: 65,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.kMediumPadding,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightBlackColor),
            color: AppColors.xtraLightGreyColor,
            borderRadius: BorderRadius.circular(45),
          ),
          child: BlocBuilder<HabitViewBloc, HabitViewState>(
            builder: (context, state) {
              final viewTag = state.viewTag;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  InkWell(
                    onTap: () {
                      context.read<HabitViewBloc>().add(
                        HabitViewEvent(viewTag: 'monthly'),
                      );
                    },
                    child: Icon(
                      Icons.grid_view_rounded,
                      color: AppColors.themeBlack.withAlpha(
                        viewTag == 'monthly' ? 255 : 180,
                      ),
                      size: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.read<HabitViewBloc>().add(
                        HabitViewEvent(viewTag: 'weekly'),
                      );
                    },
                    child: Icon(
                      Icons.horizontal_split_rounded,
                      color: AppColors.themeBlack.withAlpha(
                        viewTag == 'weekly' ? 255 : 180,
                      ),
                      size: 20,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.read<HabitViewBloc>().add(
                        HabitViewEvent(viewTag: 'yearly'),
                      );
                    },
                    child: Icon(
                      Icons.grid_on_rounded,
                      color: AppColors.themeBlack.withAlpha(
                        viewTag == 'yearly' ? 255 : 180,
                      ),
                      size: 20,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class MonthlyStreak extends StatelessWidget {
  const MonthlyStreak({super.key, required this.habit});
  final HabitModel habit;

  @override
  Widget build(BuildContext context) {
    //  final bool isPositive = habit.habitType.toLowerCase().startsWith('p');
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          backgroundColor: AppColors.transparentColor,
          context: context,
          builder: (context) {
            return HabitDetailedView(habit: habit);
          },
        );
      },
      child: Container(
        padding: AppConstants.widgetInternalPadding,

        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreyColor),
          color: AppColors.themeWhite,
          borderRadius: AppConstants.widgetMediumBorderRadius,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: double.maxFinite,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.xtraLightGreyColor,
                      borderRadius: AppConstants.widetHalfBorderRadius,
                    ),
                    child: Center(
                      child: Icon(
                        HugeIcons.strokeRoundedLeaf04,
                        color: AppColors.themeBlack,
                        size: 22,
                      ),
                    ),
                  ),
                  AppConstants.singleWidth,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          habit.title,
                          style: TypographyTheme.simpleTitleStyle(fontSize: 14),
                        ),
                        if (habit.description != '')
                          Text(
                            habit.description,
                            overflow: TextOverflow.ellipsis,
                            style: TypographyTheme.simpleSubTitleStyle(
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AppConstants.singleWidth,

                  ValueListenableBuilder(
                    valueListenable: Hive.box(
                      HiveConstants.habitValueBox,
                    ).listenable(),
                    builder: (context, valueBox, child) {
                      final today = DateTime.now();
                      final formatter = DateFormat('y-M-d');
                      final String dateToday = formatter.format(today);
                      final List todaysValueBox = valueBox.get(dateToday) ?? [];
                      final HabitsValuesModel habitValue = todaysValueBox
                          .firstWhere(
                            (val) {
                              return val.habitKey == habit.key;
                            },
                            orElse: () => HabitsValuesModel(
                              habitKey: habit.key,
                              habitVlaue: 0,
                              isHabitCompleted: false,
                            ),
                          );

                      return InkWell(
                        onTap: () async {
                          final taskService = TaskService();
                          if (habit.valueCount == 0) {
                            taskService.completeTodayHabit(
                              habit,
                              habitValue,
                              dateToday,
                              todaysValueBox,
                              valueBox,
                            );
                          } else {
                            log('Value Count is greater than Zero');
                            showModalBottomSheet(
                              backgroundColor: AppColors.transparentColor,
                              context: context,
                              builder: (context) {
                                return CustomHabitCompletion(
                                  habit: habit,
                                  specificDate: dateToday,
                                );
                              },
                            );
                          }
                        },

                        child:
                            habit.valueCount != 0 &&
                                habit.valueCount != habitValue.habitVlaue
                            ? SizedBox(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        startDegreeOffset: -90,
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 12,
                                        sections: [
                                          PieChartSectionData(
                                            value:
                                                (habitValue.habitVlaue /
                                                habit.valueCount),
                                            color:
                                                selectableColors[habit
                                                    .habitColor],
                                            radius: 5,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value:
                                                1 -
                                                (habitValue.habitVlaue /
                                                    habit.valueCount),
                                            color: AppColors.lightGreyColor,
                                            radius: 5,
                                            showTitle: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.add,
                                      size: 15,
                                      color: AppColors.themeBlack,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: selectableColors[habit.habitColor]
                                      .withAlpha(
                                        colorAlphaValue(
                                          habit.valueCount,
                                          habitValue.habitVlaue,
                                        ),
                                      ),
                                  borderRadius:
                                      AppConstants.widetHalfBorderRadius,
                                ),
                                child: Center(
                                  child: Icon(
                                    HugeIcons.strokeRoundedTick02,
                                    color: AppColors.themeBlack,
                                    size: 24,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
            AppConstants.defaultSpace,

            // Wrap(
            //   spacing: 5,
            //   runSpacing: 5,
            //   children: List.generate(30, (index) {
            //     return Container(
            //       height: 18,
            //       width: 18,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(4),
            //         color: AppColors.mainColorxLightBlue,
            //       ),
            //     );
            //   }),
            // ),
            ValueListenableBuilder(
              valueListenable: Hive.box(
                HiveConstants.habitValueBox,
              ).listenable(),
              builder: (context, valueBox, child) {
                return GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 16,
                  shrinkWrap: true,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  children: List.generate(getCurrentMonthDateStrings().length, (
                    index,
                  ) {
                    final dateKey = getCurrentMonthDateStrings()[index];
                    final List allValues = valueBox.get(dateKey) ?? [];
                    final HabitsValuesModel habitValue = allValues.firstWhere(
                      (val) {
                        return val.habitKey == habit.key;
                      },
                      orElse: () => HabitsValuesModel(
                        habitKey: habit.key,
                        habitVlaue: 0,
                        isHabitCompleted: false,
                      ),
                    );
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: selectableColors[habit.habitColor].withAlpha(
                          colorAlphaValue(
                            habit.valueCount,
                            habitValue.habitVlaue,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WeeklyHabitStreak extends StatelessWidget {
  const WeeklyHabitStreak({
    super.key,
    required this.habit,
    required this.allHabitsBox,
  });
  final HabitModel habit;
  final Box allHabitsBox;

  @override
  Widget build(BuildContext context) {
    final bool isHabitValueBinary = habit.valueCount == 0;
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          backgroundColor: AppColors.transparentColor,
          context: context,
          builder: (context) {
            return HabitDetailedView(habit: habit);
          },
        );
      },
      child: Container(
        padding: AppConstants.widgetInternalPadding,
        height: 65,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreyColor),
          color: AppColors.themeWhite,
          borderRadius: AppConstants.widetHalfBorderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: AppColors.xtraLightGreyColor,
                      borderRadius: AppConstants.widetHalfBorderRadius,
                    ),
                    child: Center(
                      child: Icon(
                        HugeIcons.strokeRoundedWatermelon,
                        color: AppColors.themeBlack,
                        size: 24,
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: Hive.box(
                          HiveConstants.habitValueBox,
                        ).listenable(),
                        builder: (context, valueBox, child) {
                          return Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: List.generate(7, (index) {
                              final dateKey =
                                  getCurrentWeekDatesAsStrings()[index];
                              log('The Date Key: $dateKey');
                              final List allValues =
                                  valueBox.get(dateKey) ?? [];

                              // final List todaysValues = valueBox.get(key)

                              final HabitsValuesModel habitValue = allValues
                                  .firstWhere(
                                    (val) {
                                      return val.habitKey == habit.key;
                                    },
                                    orElse: () => HabitsValuesModel(
                                      habitKey: habit.key,
                                      habitVlaue: 0,
                                      isHabitCompleted: false,
                                    ),
                                  );

                              return InkWell(
                                onTap: () async {
                                  final taskService = TaskService();
                                  final habitStats = HabitStatsService();
                                  if (habit.valueCount == 0) {
                                    await taskService
                                        .completeHabit(
                                          habit,
                                          habitValue,
                                          allValues,
                                          dateKey,
                                          valueBox,
                                        )
                                        .whenComplete(() async {
                                          await habitStats.calculateHabitStats(
                                            habitsBox: valueBox,
                                            allHabits: allHabitsBox,
                                            habitModel: habit,
                                          );
                                          if (habit.currentStreak ==
                                                  habit.streakGoal &&
                                              context.mounted) {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return NewLevelUnlockPopup(
                                                  userName: 'Fahad',
                                                  badgeTitle: 'Advanced',
                                                  auraPoints: 2459,
                                                );
                                              },
                                            );
                                          }
                                        });
                                  } else {
                                    log('Value Count is greater than Zero');
                                    showModalBottomSheet(
                                      backgroundColor:
                                          AppColors.transparentColor,
                                      context: context,
                                      builder: (context) {
                                        return CustomHabitCompletion(
                                          habit: habit,
                                          specificDate: dateKey,
                                        );
                                      },
                                    );
                                  }
                                },

                                child: isHabitValueBinary
                                    ? Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color:
                                              selectableColors[habit.habitColor]
                                                  .withAlpha(
                                                    habitValue.habitVlaue == 1
                                                        ? 255
                                                        : 40,
                                                  ),
                                        ),
                                      )
                                    : Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color:
                                              selectableColors[habit.habitColor]
                                                  .withAlpha(50),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.bottomCenter,
                                          widthFactor: 1,
                                          heightFactor:
                                              habitValue.habitVlaue /
                                              habit.valueCount,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  selectableColors[habit
                                                      .habitColor],
                                            ),
                                          ),
                                        ),
                                      ),
                              );
                            }),
                          );
                        },
                      ),
                      2.height,
                      Text(
                        habit.title,
                        style: TypographyTheme.simpleSubTitleStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomHabitCompletion extends StatelessWidget {
  const CustomHabitCompletion({
    super.key,
    required this.habit,
    required this.specificDate,
  });

  final HabitModel habit;
  final String specificDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.kMediumPadding),
      margin: EdgeInsets.symmetric(
        horizontal: AppConstants.kMediumPadding,
        vertical: 25,
      ),
      decoration: BoxDecoration(
        color: AppColors.creamyWhiteColor,
        borderRadius: AppConstants.widetHalfBorderRadius,
      ),
      child: Wrap(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box(HiveConstants.habitValueBox).listenable(),
            builder: (context, valueBox, child) {
              final List allValues = valueBox.get(specificDate) ?? [];

              final HabitsValuesModel habitValue = allValues.firstWhere(
                (val) {
                  return val.habitKey == habit.key;
                },
                orElse: () => HabitsValuesModel(
                  habitKey: habit.key,
                  habitVlaue: 0,
                  isHabitCompleted: false,
                ),
              );

              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppConstants.kSmallPadding),
                        decoration: BoxDecoration(
                          color: AppColors.themeWhite,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.lightGreyColor),
                        ),
                        child: Text(
                          '08.07.25',
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      5.width,
                      Text(
                        habit.title,
                        style: TypographyTheme.simpleTitleStyle(fontSize: 12),
                      ),

                      Spacer(),
                      InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.themeBlack,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  AppConstants.defaultSpace,
                  Container(
                    width: double.maxFinite,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selectableColors[habit.habitColor].withAlpha(40),
                      borderRadius: AppConstants.widetHalfBorderRadius,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (habitValue.habitVlaue / habit.valueCount),
                      heightFactor: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectableColors[habit.habitColor],
                          borderRadius: AppConstants.widetHalfBorderRadius,
                        ),
                      ),
                    ),
                  ),
                  AppConstants.defaultDoubleSpace,
                  SizedBox(
                    height: 45,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final taskService = TaskService();
                              if (habitValue.habitVlaue != 0) {
                                await taskService.decrementCustomHabit(
                                  habitValue,
                                  habit,
                                  allValues,
                                  specificDate,
                                  valueBox,
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    AppConstants.widetHalfBorderRadius,
                                color: AppColors.themeWhite,
                                border: Border.all(
                                  color: AppColors.lightGreyColor,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.minus,
                                  color: AppColors.themeBlack,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppConstants.singleWidth,
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.kSmallPadding,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: AppConstants.widetHalfBorderRadius,
                              color: AppColors.themeWhite,
                              border: Border.all(
                                color: AppColors.lightGreyColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                ' ${habitValue.habitVlaue} / ${habit.valueCount}',
                                style: TypographyTheme.simpleTitleStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        AppConstants.singleWidth,
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final taskService = TaskService();
                              await taskService.incrementCustomHabit(
                                habitValue,
                                habit,
                                allValues,
                                specificDate,
                                valueBox,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    AppConstants.widetHalfBorderRadius,
                                color: AppColors.themeWhite,
                                border: Border.all(
                                  color: AppColors.lightGreyColor,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.add,
                                  color: AppColors.themeBlack,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppConstants.defaultSpace,
                  SizedBox(
                    height: 40,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final taskService = TaskService();
                              await taskService.resetCustomHabit(
                                habitValue,
                                habit,
                                allValues,
                                specificDate,
                                valueBox,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.themeWhite,
                                borderRadius:
                                    AppConstants.widetHalfBorderRadius,
                                border: Border.all(
                                  color: AppColors.lightGreyColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Reset',
                                  style: TypographyTheme.simpleSubTitleStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppConstants.halfWidth,
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final taskService = TaskService();
                              await taskService.fillCustomHabit(
                                habitValue,
                                habit,
                                allValues,
                                specificDate,
                                valueBox,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    AppConstants.widetHalfBorderRadius,
                                color: AppColors.themeWhite,
                                border: Border.all(
                                  color: AppColors.lightGreyColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Fill',
                                  style: TypographyTheme.simpleSubTitleStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class YearlyHabitStreak extends StatelessWidget {
  const YearlyHabitStreak({super.key, required this.habit});
  final HabitModel habit;

  @override
  Widget build(BuildContext context) {
    final paddedDates = generatePaddedDates();
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          backgroundColor: AppColors.transparentColor,
          context: context,
          builder: (context) {
            return HabitDetailedView(habit: habit);
          },
        );
      },
      child: Container(
        padding: AppConstants.widgetInternalPadding,

        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreyColor),
          color: AppColors.themeWhite,
          borderRadius: AppConstants.widgetMediumBorderRadius,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: double.maxFinite,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.xtraLightGreyColor,
                      borderRadius: AppConstants.widetHalfBorderRadius,
                    ),
                    child: Center(
                      child: Icon(
                        HugeIcons.strokeRoundedWatermelon,
                        color: AppColors.themeBlack,
                        size: 22,
                      ),
                    ),
                  ),
                  AppConstants.singleWidth,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          habit.title,
                          style: TypographyTheme.simpleTitleStyle(fontSize: 14),
                        ),
                        if (habit.description != '')
                          Text(
                            habit.description,
                            overflow: TextOverflow.ellipsis,
                            style: TypographyTheme.simpleSubTitleStyle(
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AppConstants.singleWidth,

                  ValueListenableBuilder(
                    valueListenable: Hive.box(
                      HiveConstants.habitValueBox,
                    ).listenable(),
                    builder: (context, valueBox, child) {
                      final today = DateTime.now();
                      final formatter = DateFormat('y-M-d');
                      final String dateToday = formatter.format(today);
                      final List todaysValueBox = valueBox.get(dateToday) ?? [];
                      final HabitsValuesModel habitValue = todaysValueBox
                          .firstWhere(
                            (val) {
                              return val.habitKey == habit.key;
                            },
                            orElse: () => HabitsValuesModel(
                              habitKey: habit.key,
                              habitVlaue: 0,
                              isHabitCompleted: false,
                            ),
                          );

                      return InkWell(
                        onTap: () async {
                          final taskService = TaskService();

                          if (habit.valueCount == 0) {
                            await taskService.completeTodayHabit(
                              habit,
                              habitValue,
                              dateToday,
                              todaysValueBox,
                              valueBox,
                            );
                          } else {
                            log('Value Count is greater than Zero');
                            showModalBottomSheet(
                              backgroundColor: AppColors.transparentColor,
                              context: context,
                              builder: (context) {
                                return CustomHabitCompletion(
                                  habit: habit,
                                  specificDate: dateToday,
                                );
                              },
                            );
                          }
                        },

                        child:
                            habit.valueCount != 0 &&
                                habit.valueCount != habitValue.habitVlaue
                            ? SizedBox(
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        startDegreeOffset: -90,
                                        sectionsSpace: 0,
                                        centerSpaceRadius: 12,
                                        sections: [
                                          PieChartSectionData(
                                            value:
                                                (habitValue.habitVlaue /
                                                habit.valueCount),
                                            color:
                                                selectableColors[habit
                                                    .habitColor],
                                            radius: 5,
                                            showTitle: false,
                                          ),
                                          PieChartSectionData(
                                            value:
                                                1 -
                                                (habitValue.habitVlaue /
                                                    habit.valueCount),
                                            color: AppColors.lightGreyColor,
                                            radius: 5,
                                            showTitle: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.add,
                                      size: 15,
                                      color: AppColors.themeBlack,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: selectableColors[habit.habitColor]
                                      .withAlpha(
                                        colorAlphaValue(
                                          habit.valueCount,
                                          habitValue.habitVlaue,
                                        ),
                                      ),
                                  borderRadius:
                                      AppConstants.widetHalfBorderRadius,
                                ),
                                child: Center(
                                  child: Icon(
                                    HugeIcons.strokeRoundedTick02,
                                    color: AppColors.themeBlack,
                                    size: 24,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
            AppConstants.defaultSpace,
            YearlyGridView(paddedDates: paddedDates, habit: habit),
          ],
        ),
      ),
    );
  }
}

class YearlyGridView extends StatelessWidget {
  const YearlyGridView({
    super.key,
    required this.paddedDates,
    required this.habit,
  });

  final List<DateTime?> paddedDates;
  final HabitModel habit;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(HiveConstants.habitValueBox).listenable(),
      builder: (context, valueBox, child) {
        return SizedBox(
          height: (12 + 2) * 7, // 7 rows × (box height + spacing)
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: paddedDates.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 rows = 1 column per week
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              final date = paddedDates[index];

              final formatter = DateFormat('y-M-d');
              final theDate = date != null ? formatter.format(date) : '';
              final List allValues = valueBox.get(theDate) ?? [];
              final HabitsValuesModel habitValue = allValues.firstWhere(
                (val) {
                  return val.habitKey == habit.key;
                },
                orElse: () => HabitsValuesModel(
                  habitKey: habit.key,
                  habitVlaue: 0,
                  isHabitCompleted: false,
                ),
              );

              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: selectableColors[habit.habitColor].withAlpha(
                    colorAlphaValue(habit.valueCount, habitValue.habitVlaue),
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class HabitDetailedView extends StatelessWidget {
  const HabitDetailedView({super.key, required this.habit});
  final HabitModel habit;

  @override
  Widget build(BuildContext context) {
    final paddedDates = generatePaddedDates();
    return Wrap(
      children: [
        Container(
          // height: double.maxFinite,
          padding: EdgeInsets.all(AppConstants.kMediumPadding),
          margin: EdgeInsets.symmetric(
            horizontal: AppConstants.kMediumPadding,
            vertical: 25,
          ),
          decoration: BoxDecoration(
            color: AppColors.creamyWhiteColor,
            borderRadius: AppConstants.widetHalfBorderRadius,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40,
                width: double.maxFinite,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.xtraLightGreyColor,
                        borderRadius: AppConstants.widetHalfBorderRadius,
                      ),
                      child: Center(
                        child: Icon(
                          HugeIcons.strokeRoundedWatermelon,
                          color: AppColors.themeBlack,
                          size: 22,
                        ),
                      ),
                    ),
                    AppConstants.singleWidth,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            habit.title,
                            style: TypographyTheme.simpleTitleStyle(
                              fontSize: 14,
                            ),
                          ),
                          if (habit.description != '')
                            Text(
                              habit.description,
                              overflow: TextOverflow.ellipsis,
                              style: TypographyTheme.simpleSubTitleStyle(
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    AppConstants.singleWidth,

                    Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: AppColors.themeWhite,
                        borderRadius: AppConstants.widetHalfBorderRadius,
                        border: Border.all(color: AppColors.lightGreyColor),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: AppColors.themeBlack,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppConstants.defaultSpace,
              //   YearlyGridView(paddedDates: paddedDates, habit: habit),
              AppConstants.defaultSpace,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.kMediumPadding,
                      vertical: AppConstants.kSmallPadding,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: AppConstants.widetHalfBorderRadius,
                      color: AppColors.themeWhite,
                      border: Border.all(color: AppColors.lightGreyColor),
                    ),
                    child: Row(
                      children: [
                        Text(
                          habit.streakGoal.toString(),
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 13,
                          ),
                        ),
                        2.width,
                        Icon(
                          CupertinoIcons.flame,
                          size: 15,
                          color: AppColors.themeBlack,
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      context.pushNamed(
                        RouteConstants.editHabitsPageName,
                        extra: habit,
                      );
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: AppColors.themeWhite,
                        borderRadius: AppConstants.widetHalfBorderRadius,
                        border: Border.all(color: AppColors.lightGreyColor),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.edit,
                          color: AppColors.themeBlack,
                          size: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.defaultDoubleSpace,
              ColoredBox(
                color: AppColors.lightGreyColor,
                child: SizedBox(height: 0.7, width: double.maxFinite),
              ),
              AppConstants.defaultDoubleSpace,
              HabitCalenderView(habitColor: selectableColors[habit.habitColor]),
            ],
          ),
        ),
      ],
    );
  }
}

class HabitCalenderView extends StatefulWidget {
  const HabitCalenderView({super.key, required this.habitColor});
  final Color habitColor;

  @override
  State<HabitCalenderView> createState() => _HabitCalenderViewState();
}

class _HabitCalenderViewState extends State<HabitCalenderView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekVisible: true,
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: AppColors.redColor),
        weekdayStyle: TextStyle(color: AppColors.themeBlack),
      ),
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },

      // 👇 This part customizes each cell
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, isSelected: false);
        },
        selectedBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, isSelected: true);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildDayCell(day, isToday: true);
        },
      ),
    );
  }

  // 👇 Custom Day Cell Widget
  Widget _buildDayCell(
    DateTime day, {
    bool isSelected = false,
    bool isToday = false,
  }) {
    Color bgColor = isSelected
        ? widget.habitColor.withAlpha(80)
        : AppColors.transparentColor;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.kSmallPadding),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
            ),
            3.height,
            // 👇 Tiny colored circle
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color:
                    widget.habitColor, // You can change based on habit status
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
