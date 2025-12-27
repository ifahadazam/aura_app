import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:life_goal/features/goals/data/services/habit_stats_service.dart';

class MonthlyLineChart extends StatelessWidget {
  const MonthlyLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final habitStats = HabitStatsService();
    return ValueListenableBuilder(
      valueListenable: Hive.box<HabitModel>(
        HiveConstants.habitsBox,
      ).listenable(),
      builder: (context, habitBox, child) {
        return ValueListenableBuilder(
          valueListenable: Hive.box(HiveConstants.unitValuesBox).listenable(),
          builder: (context, unitValues, child) {
            final monthlyDuration =
                unitValues.get(HiveConstants.selectedMonthlyDuration) ?? 'p28';
            final monthlyData = monthlyDuration == 'p28'
                ? habitStats.getLast28DaysHabitCompletion(habitsBox: habitBox)
                : habitStats.getCurrentMonth28DaysHabitCompletion(
                    habitsBox: habitBox,
                  );
            return monthlyData.isEmpty
                ? Center(
                    child: Text(
                      'No Data Available',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
                    ),
                  )
                : LineChart(mainData(monthlyData));
          },
        );
      },
    );
  }

  LineChartData mainData(Map<String, Map<String, dynamic>> monthlyData) {
    final dateKeys = monthlyData.keys.toList();

    return LineChartData(
      gridData: FlGridData(show: false),

      titlesData: FlTitlesData(
        show: false,

        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 1,
            interval: 1,
            // getTitlesWidget: bottomTitleWidgets,
          ),
        ),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            // getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),

      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(dateKeys.length, (index) {
            final date = dateKeys[index];
            final int completionValue =
                monthlyData[date]!['numberOfCompletions'];
            return FlSpot(index.toDouble(), completionValue.toDouble());
          }),
          // spots: const [
          //   FlSpot(0, 3),
          //   FlSpot(2.6, 2),
          //   FlSpot(4.9, 5),
          //   FlSpot(6.8, 3.1),
          //   FlSpot(8, 4),
          //   FlSpot(9.5, 3),
          //   FlSpot(11, 4),
          // ],
          isCurved: true,
          color: AppColors.themeBlack,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }
}
