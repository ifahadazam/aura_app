import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:life_goal/features/progress/presentation/widgets/monthly_line_chart.dart';
import 'package:life_goal/features/progress/presentation/widgets/weekly_bar_graph.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final ValueNotifier switchGraph = ValueNotifier<bool>(false);

  @override
  void dispose() {
    super.dispose();
    switchGraph.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: AppConstants.widgetInternalPadding,
        child: Column(
          spacing: 8,
          children: [
            HabitStats(),
            DefaultTabController(
              length: 2,
              child: Container(
                padding: EdgeInsets.all(AppConstants.kMediumPadding / 2),
                height: 45,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: AppConstants.widetHalfBorderRadius,
                  color: AppColors.themeWhite,
                  border: Border.all(color: AppColors.lightGreyColor),
                ),
                child: TabBar(
                  onTap: (val) {
                    if (val == 0) {
                      switchGraph.value = false;
                    } else {
                      switchGraph.value = true;
                    }
                  },
                  labelColor: AppColors.themeWhite,
                  unselectedLabelColor: AppColors.lightBlackColor,
                  labelStyle: TypographyTheme.simpleTitleStyle(fontSize: 13),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    // color: AppColors.prominentColor3,
                    color: AppColors.themeBlack,
                    borderRadius: AppConstants.widetHalfBorderRadius,
                  ),
                  tabs: [
                    Tab(text: 'Weekly'),
                    Tab(text: 'Monthly'),
                  ],
                ),
              ),
            ),

            ValueListenableBuilder(
              valueListenable: Hive.box(
                HiveConstants.unitValuesBox,
              ).listenable(),
              builder: (context, unitValues, child) {
                final weekDuration =
                    unitValues.get(HiveConstants.selectedWeeklyDuration) ??
                    'p7';

                final monthlyDuration =
                    unitValues.get(HiveConstants.selectedMonthlyDuration) ??
                    'p28';

                return ValueListenableBuilder(
                  valueListenable: switchGraph,
                  builder: (context, isSwitched, child) {
                    return Container(
                      padding: AppConstants.widgetInternalPadding,
                      decoration: BoxDecoration(
                        color: AppColors.themeWhite,
                        borderRadius: AppConstants.widgetBorderRadius,
                        border: Border.all(color: AppColors.xtraLightGreyColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.xtraLightGreyColor,
                                      borderRadius:
                                          AppConstants.widgetMediumBorderRadius,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        isSwitched
                                            ? Icons.show_chart_rounded
                                            : Icons.bar_chart_rounded,
                                      ),
                                    ),
                                  ),
                                  AppConstants.singleWidth,
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isSwitched
                                            ? 'Monthly Completions'
                                            : 'Weekly Completions',
                                        style: TypographyTheme.simpleTitleStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        isSwitched
                                            ? monthlyDuration == 'p28'
                                                  ? 'Last 28 Days'
                                                  : 'Current 28 Days'
                                            : weekDuration == 'p7'
                                            ? 'Last 7 Days'
                                            : 'Current 7 Days',
                                        style:
                                            TypographyTheme.simpleSubTitleStyle(
                                              fontSize: 13,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              //Spacer(),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: AppColors.themeWhite,
                                    showDragHandle: true,
                                    enableDrag: true,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(
                                          AppConstants.kLargePadding,
                                        ),
                                        child: Wrap(
                                          children: [
                                            Text(
                                              'Duration',
                                              style:
                                                  TypographyTheme.simpleTitleStyle(
                                                    fontSize: 16,
                                                  ),
                                            ),
                                            AppConstants.defaultDoubleSpace,
                                            AppConstants.defualtHalfSpace,
                                            isSwitched
                                                ? Column(
                                                    children: [
                                                      SelectStatDuration(
                                                        onTap: () {
                                                          unitValues.put(
                                                            HiveConstants
                                                                .selectedMonthlyDuration,
                                                            'p28',
                                                          );
                                                          context.pop();
                                                        },
                                                        title: 'Past 28 Days',
                                                        isSelected:
                                                            monthlyDuration ==
                                                            'p28',
                                                      ),
                                                      AppConstants
                                                          .defualtHalfSpace,
                                                      SelectStatDuration(
                                                        onTap: () {
                                                          unitValues.put(
                                                            HiveConstants
                                                                .selectedMonthlyDuration,
                                                            'c28',
                                                          );
                                                          context.pop();
                                                        },
                                                        title:
                                                            'Current 28 Days',
                                                        isSelected:
                                                            monthlyDuration ==
                                                            'c28',
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      SelectStatDuration(
                                                        onTap: () {
                                                          unitValues.put(
                                                            HiveConstants
                                                                .selectedWeeklyDuration,
                                                            'p7',
                                                          );
                                                          context.pop();
                                                        },
                                                        title: 'Past 7 Days',
                                                        isSelected:
                                                            weekDuration ==
                                                            'p7',
                                                      ),
                                                      AppConstants
                                                          .defualtHalfSpace,
                                                      SelectStatDuration(
                                                        onTap: () {
                                                          unitValues.put(
                                                            HiveConstants
                                                                .selectedWeeklyDuration,
                                                            'c7',
                                                          );
                                                          context.pop();
                                                        },
                                                        title: 'Current 7 Days',
                                                        isSelected:
                                                            weekDuration ==
                                                            'c7',
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.xtraLightGreyColor,
                                    borderRadius:
                                        AppConstants.widgetMediumBorderRadius,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          AppConstants.defaultDoubleSpace,
                          AspectRatio(
                            aspectRatio: 1.60,
                            child: isSwitched
                                ? MonthlyLineChart()
                                : WeeklyBarGraph(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SelectStatDuration extends StatelessWidget {
  const SelectStatDuration({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: AppConstants.kSmallPadding / 1.5,
        ),
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: AppConstants.kLargePadding),
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: AppColors.themeBlack, width: 1.0)
              : null,
          borderRadius: AppConstants.widgetMediumBorderRadius,
          color: AppColors.xtraLightGreyColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
            ),
            Icon(
              Icons.bar_chart_rounded,
              color: AppColors.themeBlack,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class HabitStats extends StatelessWidget {
  const HabitStats({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<HabitModel>(
        HiveConstants.habitsBox,
      ).listenable(),
      builder: (context, allHabitsBox, child) {
        final allHabits = allHabitsBox.values.toList();
        return ValueListenableBuilder(
          valueListenable: Hive.box(HiveConstants.unitValuesBox).listenable(),
          builder: (context, unitBox, child) {
            final selectedHabit =
                unitBox.get(HiveConstants.selectedHabitStat) ?? '';
            final choosedHabit = allHabitsBox.get(selectedHabit);

            // Values to show if no habit is selected ofr stats.
            // It includes
            int maxCurrentStreak = allHabits.isEmpty
                ? 0
                : allHabits
                      .map((h) => h.currentStreak!)
                      .reduce((a, b) => a > b ? a : b);
            int maxBestStreak = allHabits.isEmpty
                ? 0
                : allHabits
                      .map((h) => h.bestStreak!)
                      .reduce((a, b) => a > b ? a : b);
            int totalTrackedDays = allHabits.fold(
              0,
              (sum, h) => sum + h.totalTrackedDays!,
            );

            int totalCompletedDays = allHabits.fold(
              0,
              (sum, h) => sum + h.totalCompletedDays!,
            );

            int totalSkippedDays = allHabits.fold(
              0,
              (sum, h) => sum + h.totalSkippedDays!,
            );

            return allHabits.isEmpty
                ? AllHabitStats(
                    totalDaysTracked: 0,
                    completedDays: 0,
                    skippedDays: 0,
                    currentStreak: 0,
                    bestStreak: 0,
                    completionRate: 0.0,
                  )
                : selectedHabit == ''
                ? AllHabitStats(
                    totalDaysTracked: totalTrackedDays,
                    completedDays: totalCompletedDays,
                    skippedDays: totalSkippedDays,
                    currentStreak: maxCurrentStreak,
                    bestStreak: maxBestStreak,
                    completionRate: totalCompletedDays / totalTrackedDays,
                  )
                : AllHabitStats(
                    totalDaysTracked: choosedHabit?.totalTrackedDays ?? 0,
                    completedDays: choosedHabit?.totalCompletedDays ?? 0,
                    skippedDays: choosedHabit?.totalSkippedDays ?? 0,
                    currentStreak: choosedHabit?.currentStreak ?? 0,
                    bestStreak: choosedHabit?.bestStreak ?? 0,
                    completionRate: choosedHabit?.completionRate ?? 0,
                  );
          },
        );
      },
    );
  }
}

class AllHabitStats extends StatelessWidget {
  const AllHabitStats({
    super.key,
    required this.totalDaysTracked,
    required this.completedDays,
    required this.skippedDays,
    required this.currentStreak,
    required this.bestStreak,
    required this.completionRate,
  });
  final int totalDaysTracked;
  final int completedDays;
  final int skippedDays;
  final int currentStreak;
  final int bestStreak;
  final double completionRate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<HabitModel>(
        HiveConstants.habitsBox,
      ).listenable(),
      builder: (context, habitsBox, child) {
        final allHabits = habitsBox.values.toList();
        return ValueListenableBuilder(
          valueListenable: Hive.box(HiveConstants.unitValuesBox).listenable(),
          builder: (context, unitValues, child) {
            final selectedHabit =
                unitValues.get(HiveConstants.selectedHabitStat) ?? '';
            final currentHabit = selectedHabit == ''
                ? null
                : habitsBox.get(selectedHabit);
            final selectedHabitName = currentHabit != null
                ? currentHabit.title
                : 'All Habits';

            return Container(
              height: 240,
              width: double.maxFinite,
              padding: AppConstants.widgetInternalPadding,
              decoration: BoxDecoration(
                color: AppColors.themeWhite,
                borderRadius: AppConstants.widgetBorderRadius,
                border: Border.all(color: AppColors.lightGreyColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.xtraLightGreyColor,
                          borderRadius: AppConstants.widgetMediumBorderRadius,
                        ),
                        child: Center(
                          child: Icon(HugeIcons.strokeRoundedGridView),
                        ),
                      ),
                      AppConstants.singleWidth,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedHabitName,
                            style: TypographyTheme.simpleTitleStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Summary',
                            style: TypographyTheme.simpleSubTitleStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: AppColors.themeWhite,
                            showDragHandle: true,
                            enableDrag: true,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(
                                  AppConstants.kLargePadding,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Choose Habit',
                                      style: TypographyTheme.simpleTitleStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    AppConstants.defaultDoubleSpace,
                                    AppConstants.defualtHalfSpace,
                                    InkWell(
                                      onTap: () async {
                                        await Hive.box(
                                          HiveConstants.unitValuesBox,
                                        ).put(
                                          HiveConstants.selectedHabitStat,
                                          '',
                                        );
                                        if (context.mounted) {
                                          context.pop();
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical:
                                              AppConstants.kSmallPadding / 1.5,
                                        ),
                                        height: 45,
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              AppConstants.kLargePadding,
                                        ),
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          border: selectedHabit == ''
                                              ? Border.all(
                                                  color: AppColors.themeBlack,
                                                  width: 1.0,
                                                )
                                              : null,
                                          borderRadius: AppConstants
                                              .widgetMediumBorderRadius,
                                          color: AppColors.xtraLightGreyColor,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'All Habits',
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  TypographyTheme.simpleSubTitleStyle(
                                                    fontSize: 14,
                                                  ),
                                            ),
                                            Icon(
                                              CupertinoIcons
                                                  .rectangle_grid_2x2_fill,
                                              color: AppColors.themeBlack,
                                              size: 22,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    allHabits.isEmpty
                                        ? SizedBox.shrink()
                                        : Expanded(
                                            child: ListView.builder(
                                              itemCount: allHabits.length,

                                              itemBuilder: (context, index) {
                                                final HabitModel eachHabit =
                                                    allHabits[index];
                                                return InkWell(
                                                  onTap: () async {
                                                    log(
                                                      'HK: ${eachHabit.habitKey}',
                                                    );
                                                    log(
                                                      'SelectedHabit: $selectedHabit',
                                                    );
                                                    await Hive.box(
                                                      HiveConstants
                                                          .unitValuesBox,
                                                    ).put(
                                                      HiveConstants
                                                          .selectedHabitStat,
                                                      eachHabit.habitKey,
                                                    );
                                                    if (context.mounted) {
                                                      context.pop();
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(
                                                      vertical:
                                                          AppConstants
                                                              .kSmallPadding /
                                                          1.5,
                                                    ),
                                                    height: 45,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              AppConstants
                                                                  .kLargePadding,
                                                        ),
                                                    width: double.maxFinite,
                                                    decoration: BoxDecoration(
                                                      border:
                                                          eachHabit.habitKey ==
                                                              selectedHabit
                                                          ? Border.all(
                                                              color: AppColors
                                                                  .themeBlack,
                                                              width: 1.0,
                                                            )
                                                          : null,
                                                      borderRadius: AppConstants
                                                          .widgetMediumBorderRadius,
                                                      color: AppColors
                                                          .xtraLightGreyColor,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          eachHabit.title,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              TypographyTheme.simpleSubTitleStyle(
                                                                fontSize: 14,
                                                              ),
                                                        ),
                                                        Icon(
                                                          CupertinoIcons
                                                              .rectangle_grid_2x2_fill,
                                                          color: AppColors
                                                              .themeBlack,
                                                          size: 22,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.xtraLightGreyColor,
                            borderRadius: AppConstants.widgetMediumBorderRadius,
                          ),
                          child: Center(
                            child: Icon(Icons.keyboard_arrow_down_rounded),
                          ),
                        ),
                      ),
                    ],
                  ),

                  AppConstants.defaultSpace,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: AppConstants.kMediumPadding,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'DAYS TRACKED',
                                      style:
                                          TypographyTheme.simpleSubTitleStyle(
                                            fontSize: 11,
                                          ).copyWith(
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      totalDaysTracked.toString(),
                                      style: TypographyTheme.simpleTitleStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CURRENT STREAK',
                                      style:
                                          TypographyTheme.simpleSubTitleStyle(
                                            fontSize: 11,
                                          ).copyWith(
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      currentStreak.toString(),
                                      style: TypographyTheme.simpleTitleStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'TOTAL COMPLETIOS',
                                      style:
                                          TypographyTheme.simpleSubTitleStyle(
                                            fontSize: 11,
                                          ).copyWith(
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      completedDays.toString(),
                                      style: TypographyTheme.simpleTitleStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SKIPPED DAYS',
                                      style:
                                          TypographyTheme.simpleSubTitleStyle(
                                            fontSize: 11,
                                          ).copyWith(
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      skippedDays.toString(),
                                      style: TypographyTheme.simpleTitleStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'BEST STREAK',
                                      style:
                                          TypographyTheme.simpleSubTitleStyle(
                                            fontSize: 11,
                                          ).copyWith(
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      bestStreak.toString(),
                                      style: TypographyTheme.simpleTitleStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'COMPLETION RATE',
                                      style:
                                          TypographyTheme.simpleSubTitleStyle(
                                            fontSize: 11,
                                          ).copyWith(
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      '${(completionRate * 100).toStringAsFixed(2)}%',
                                      style: TypographyTheme.simpleTitleStyle(
                                        fontSize: 16,
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class LevelNPointsWidget extends StatelessWidget {
  const LevelNPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      width: double.maxFinite,
      padding: AppConstants.widgetInternalPadding,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGreyColor),
        color: AppColors.themeWhite,
        borderRadius: AppConstants.widgetBorderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 60,
            decoration: BoxDecoration(
              color: AppColors.xtraLightGreyColor,
              borderRadius: AppConstants.widgetMediumBorderRadius,
            ),
            child: Center(
              child: Icon(
                HugeIcons.strokeRoundedMedal07,
                size: 42,
                color: AppColors.themeBlack,
              ),
            ),
          ),
          AppConstants.singleWidth,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'level-02',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1125 Xp',
                      style: TypographyTheme.simpleTitleStyle(fontSize: 17),
                    ),
                    Text(
                      '45%',
                      style: TypographyTheme.simpleTitleStyle(fontSize: 15),
                    ),
                  ],
                ),
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
                    widthFactor: 0.45,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: AppConstants.widgetBorderRadius,
                        color: AppColors.themeBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // child: Column(
      //   children: [
      //     Align(
      //       alignment: Alignment.topCenter,
      //       child: Column(
      //         children: [
      //           Icon(
      //             HugeIcons.strokeRoundedMedal06,
      //             size: 45,
      //             color: AppColors.themeBlack,
      //           ),
      //           //  AppConstants.defaultSpace,
      //           Text(
      //             'Leve-01',
      //             style: TypographyTheme.simpleTitleStyle(fontSize: 22),
      //           ),
      //         ],
      //       ),
      //     ),
      //     AppConstants.defaultSpace,
      //     Container(
      //       padding: EdgeInsets.symmetric(
      //         vertical: AppConstants.kLargePadding,
      //       ),
      //       decoration: BoxDecoration(
      //         color: AppColors.xtraLightGreyColor,
      //         borderRadius: AppConstants.widgetMediumBorderRadius,
      //       ),
      //       child: Column(
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Reward Points',
      //                     style: TypographyTheme.simpleSubTitleStyle(
      //                       fontSize: 13,
      //                     ),
      //                   ),
      //                   Text(
      //                     '895 Xp',
      //                     style: TypographyTheme.simpleTitleStyle(
      //                       fontSize: 16,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Days Tracked',
      //                     style: TypographyTheme.simpleSubTitleStyle(
      //                       fontSize: 13,
      //                     ),
      //                   ),
      //                   Text(
      //                     '30',
      //                     style: TypographyTheme.simpleTitleStyle(
      //                       fontSize: 16,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Current Streak',
      //                     style: TypographyTheme.simpleSubTitleStyle(
      //                       fontSize: 13,
      //                     ),
      //                   ),
      //                   Text(
      //                     '12',
      //                     style: TypographyTheme.simpleTitleStyle(
      //                       fontSize: 16,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Best Streak',
      //                     style: TypographyTheme.simpleSubTitleStyle(
      //                       fontSize: 13,
      //                     ),
      //                   ),
      //                   Text(
      //                     '21',
      //                     style: TypographyTheme.simpleTitleStyle(
      //                       fontSize: 16,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Total Completion',
      //                     style: TypographyTheme.simpleSubTitleStyle(
      //                       fontSize: 13,
      //                     ),
      //                   ),
      //                   Text(
      //                     '33',
      //                     style: TypographyTheme.simpleTitleStyle(
      //                       fontSize: 16,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Completion Rate',
      //                     style: TypographyTheme.simpleSubTitleStyle(
      //                       fontSize: 13,
      //                     ),
      //                   ),
      //                   Text(
      //                     '60%',
      //                     style: TypographyTheme.simpleTitleStyle(
      //                       fontSize: 16,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
