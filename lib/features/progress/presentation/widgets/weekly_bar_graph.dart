import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/goals/data/services/habit_stats_service.dart';

class WeeklyBarGraph extends StatelessWidget {
  const WeeklyBarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(HiveConstants.habitValueBox).listenable(),
      builder: (context, habits, child) {
        final habitStats = HabitStatsService();

        return ValueListenableBuilder(
          valueListenable: Hive.box(HiveConstants.unitValuesBox).listenable(),
          builder: (context, unitValues, child) {
            final int totalHabitCount =
                unitValues.get(HiveConstants.totalHabitCount) ?? 5;
            final weekDuration =
                unitValues.get(HiveConstants.selectedWeeklyDuration) ?? 'p7';

            //p7 --> Past 7 Days
            //c7 --> Current 7 Days
            final weeklyData = weekDuration == 'c7'
                ? habitStats.getCurrentWeekHabitCompletion(habitsBox: habits)
                : habitStats.getLast7DaysHabitCompletion(habitsBox: habits);
            final daysList = weeklyData.keys.toList();
            return BarChart(
              BarChartData(
                //  barTouchData: null,
                barTouchData: barTouchData,
                titlesData: titlesData(daysList),
                borderData: borderData,
                barGroups: barGroups(weeklyData, totalHabitCount),
                gridData: const FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: totalHabitCount.toDouble(),
              ),
            );
          },
        );
      },
    );
  }
}

BarTouchData get barTouchData => BarTouchData(
  enabled: false,
  touchTooltipData: BarTouchTooltipData(
    getTooltipColor: (group) => Colors.transparent,
    tooltipPadding: EdgeInsets.zero,
    tooltipMargin: 12,

    // getTooltipItem:
    //     (
    //       BarChartGroupData group,
    //       int groupIndex,
    //       BarChartRodData rod,
    //       int rodIndex,
    //     ) {
    //       return BarTooltipItem(
    //         rod.toY.round().toString(),
    //         TextStyle(
    //           color: AppColors.lightBlackColor,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       );
    //     },
  ),
);

Widget getTitles(double value, TitleMeta meta) {
  final style = TypographyTheme.simpleSubTitleStyle(fontSize: 13);
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Mn';
      break;
    case 1:
      text = 'Te';
      break;
    case 2:
      text = 'Wd';
      break;
    case 3:
      text = 'Tu';
      break;
    case 4:
      text = 'Fr';
      break;
    case 5:
      text = 'St';
      break;
    case 6:
      text = 'Sn';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    meta: meta,
    space: 4,
    child: Text(text, style: style),
  );
}

FlTitlesData titlesData(List<String> days) {
  return FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      // axisNameWidget: Text(
      //   'Habits Completion',
      //   style: TypographyTheme.simpleTitleStyle(
      //     fontSize: 11,
      //   ).copyWith(color: AppColors.darkGreyColor),
      // ),
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          final eachDay = days[value.toInt()];
          log('Each Day: $eachDay');
          return SideTitleWidget(
            meta: meta,
            child: Text(
              eachDay.substring(0, 3).toUpperCase(),
              style: TypographyTheme.simpleSubTitleStyle(fontSize: 12),
            ),
          );
        },
      ),
    ),
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );
}

FlBorderData get borderData => FlBorderData(show: false);

List<BarChartGroupData> barGroups(
  Map<String, Map<String, dynamic>> weeklyData,
  int totalHabitCount,
) {
  log('The Weekly Data: $weeklyData');
  final days = weeklyData.keys.toList();

  return List.generate(days.length, (index) {
    final theKey = days[index];
    final int habitCompletionCount = weeklyData[theKey]!['numberOfCompletions'];
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          width: 15,
          toY: habitCompletionCount.toDouble(),
          color: AppColors.themeBlack,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: totalHabitCount.toDouble(),
            color: AppColors.lightGreyColor,
          ),
        ),
      ],
      //  showingTooltipIndicators: [0],
    );
  });

  // return [
  //   BarChartGroupData(
  //     x: 0,
  //     barRods: [
  //       BarChartRodData(
  //         width: 15,
  //         toY: 8,
  //         color: AppColors.themeBlack,
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 18,
  //           color: AppColors.lightGreyColor,
  //         ),
  //       ),
  //     ],
  //     //  showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 1,
  //     barRods: [
  //       BarChartRodData(
  //         width: 15,
  //         toY: 10,
  //         color: AppColors.themeBlack,
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 18,
  //           color: AppColors.lightGreyColor,
  //         ),
  //       ),
  //     ],
  //     //  showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 2,
  //     barRods: [
  //       BarChartRodData(
  //         width: 15,
  //         toY: 3,
  //         color: AppColors.themeBlack,
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 18,
  //           color: AppColors.lightGreyColor,
  //         ),
  //       ),
  //     ],
  //     //  showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 3,
  //     barRods: [
  //       BarChartRodData(
  //         width: 15,
  //         toY: 11,
  //         color: AppColors.themeBlack,
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 18,
  //           color: AppColors.lightGreyColor,
  //         ),
  //       ),
  //     ],
  //     // showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 4,
  //     barRods: [
  //       BarChartRodData(
  //         width: 15,
  //         toY: 10,
  //         color: AppColors.themeBlack,
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 18,
  //           color: AppColors.lightGreyColor,
  //         ),
  //       ),
  //     ],
  //     // showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 5,
  //     barRods: [
  //       BarChartRodData(
  //         width: 15,
  //         toY: 5,
  //         color: AppColors.themeBlack,
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 18,
  //           color: AppColors.lightGreyColor,
  //         ),
  //       ),
  //     ],
  //     // showingTooltipIndicators: [0],
  //   ),
  //   BarChartGroupData(
  //     x: 6,
  //     barRods: [
  //       BarChartRodData(
  //         width: 15,
  //         toY: 13,
  //         color: AppColors.themeBlack,
  //         backDrawRodData: BackgroundBarChartRodData(
  //           show: true,
  //           toY: 18,
  //           color: AppColors.lightGreyColor,
  //         ),
  //       ),
  //     ],
  //     // showingTooltipIndicators: [0],
  //   ),
  // ];
}
