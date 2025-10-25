import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';

class WeeklyBarGraph extends StatelessWidget {
  const WeeklyBarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }
}

BarTouchData get barTouchData => BarTouchData(
  enabled: false,
  touchTooltipData: BarTouchTooltipData(
    getTooltipColor: (group) => Colors.transparent,
    tooltipPadding: EdgeInsets.zero,
    tooltipMargin: 8,
    getTooltipItem:
        (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.round().toString(),
            TextStyle(
              color: AppColors.lightBlackColor,
              fontWeight: FontWeight.bold,
            ),
          );
        },
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

FlTitlesData get titlesData => FlTitlesData(
  show: true,
  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 30,
      getTitlesWidget: getTitles,
    ),
  ),
  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
);

FlBorderData get borderData => FlBorderData(show: false);

List<BarChartGroupData> get barGroups => [
  BarChartGroupData(
    x: 0,
    barRods: [BarChartRodData(toY: 8, color: AppColors.themeBlack)],
    showingTooltipIndicators: [0],
  ),
  BarChartGroupData(
    x: 1,
    barRods: [BarChartRodData(toY: 10, color: AppColors.themeBlack)],
    showingTooltipIndicators: [0],
  ),
  BarChartGroupData(
    x: 2,
    barRods: [BarChartRodData(toY: 3, color: AppColors.themeBlack)],
    showingTooltipIndicators: [0],
  ),
  BarChartGroupData(
    x: 3,
    barRods: [BarChartRodData(toY: 11, color: AppColors.themeBlack)],
    showingTooltipIndicators: [0],
  ),
  BarChartGroupData(
    x: 4,
    barRods: [BarChartRodData(toY: 10, color: AppColors.themeBlack)],
    showingTooltipIndicators: [0],
  ),
  BarChartGroupData(
    x: 5,
    barRods: [BarChartRodData(toY: 5, color: AppColors.themeBlack)],
    showingTooltipIndicators: [0],
  ),
  BarChartGroupData(
    x: 6,
    barRods: [BarChartRodData(toY: 13, color: AppColors.themeBlack)],
    showingTooltipIndicators: [0],
  ),
];
