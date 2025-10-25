import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';

class DateNDay extends StatelessWidget {
  const DateNDay({
    super.key,
    this.isToday,
    required this.date,
    required this.weekDay,
  });
  final bool? isToday;
  final String weekDay;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.kMediumPadding,
          horizontal: AppConstants.kSmallPadding,
        ),
        decoration: BoxDecoration(
          color: isToday ?? false
              ? AppColors.themeBlack
              : AppColors.transparentColor,
          borderRadius: BorderRadius.circular(60),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekDay,
              textAlign: TextAlign.center,
              style: TypographyTheme.simpleSubTitleStyle(fontSize: 13).copyWith(
                color: isToday ?? false
                    ? AppColors.themeWhite
                    : AppColors.lightBlackColor,
              ),
            ),
            AppConstants.defualtHalfSpace,
            Text(
              date,
              style: TypographyTheme.simpleTitleStyle(fontSize: 13).copyWith(
                color: isToday ?? false
                    ? AppColors.themeWhite
                    : AppColors.lightBlackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
