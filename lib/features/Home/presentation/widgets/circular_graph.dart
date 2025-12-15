import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:life_goal/core/constants/app_colors.dart';

class CircularGraph extends StatelessWidget {
  const CircularGraph({
    super.key,
    required this.completedValue,
    required this.iconData,
  });
  final double completedValue;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: 26,
              sections: [
                PieChartSectionData(
                  value: completedValue.toDouble(),
                  color: AppColors.themeBlack,
                  radius: 7,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: 1 - completedValue.toDouble(),
                  color: AppColors.lightGreyColor,
                  radius: 7,
                  showTitle: false,
                ),
              ],
            ),
          ),
          Icon(
            completedValue == 1.0 ? Icons.task_alt_rounded : iconData,
            size: 18,
            color: AppColors.themeBlack,
          ),
        ],
      ),
    );
  }
}
