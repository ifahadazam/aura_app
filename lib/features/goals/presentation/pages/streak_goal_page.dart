import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/shared/internal_page_app_bar.dart';

class StreakGoalPage extends StatelessWidget {
  const StreakGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamyWhiteColor,
      appBar: InternalPageAppBar(
        title: 'Streak Goal',
        themeColor: AppColors.themeBlack,
      ),
      body: Padding(
        padding: AppConstants.pagesInternalPadding,
        child: Column(
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
              child: Column(
                children: [
                  TileButton(title: 'None'),
                  ColoredBox(
                    color: AppColors.lightGreyColor,
                    child: SizedBox(height: 1, width: double.maxFinite),
                  ),
                  TileButton(title: 'Daily'),
                  ColoredBox(
                    color: AppColors.lightGreyColor,
                    child: SizedBox(height: 1, width: double.maxFinite),
                  ),
                  TileButton(title: 'Weekly'),
                  ColoredBox(
                    color: AppColors.lightGreyColor,
                    child: SizedBox(height: 1, width: double.maxFinite),
                  ),
                  TileButton(title: 'Monthly'),
                ],
              ),
            ),
            AppConstants.defaultDoubleSpace,
            SizedBox(
              height: 60,
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Completions Per Interval',
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 12,
                          ),
                        ),
                        AppConstants.defualtHalfSpace,
                        Expanded(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  ' 2',
                                  style: TypographyTheme.simpleTitleStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  ' / Day',
                                  style: TypographyTheme.simpleSubTitleStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppConstants.singleWidth,
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '',
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 12,
                          ),
                        ),
                        AppConstants.defualtHalfSpace,

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: AppConstants.widetHalfBorderRadius,
                              color: AppColors.themeWhite,
                              border: Border.all(
                                color: AppColors.lightGreyColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: Center(
                                      child: Icon(
                                        CupertinoIcons.minus,
                                        color: AppColors.themeBlack,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 2,
                                  color: AppColors.greyColor,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Center(
                                      child: Icon(
                                        CupertinoIcons.add,
                                        color: AppColors.themeBlack,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

class TileButton extends StatelessWidget {
  const TileButton({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TypographyTheme.simpleTitleStyle(fontSize: 13)),
          Icon(Icons.done, size: 20, color: AppColors.themeBlack),
        ],
      ),
    );
  }
}
