import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:life_goal/config/routes/app_route_constants.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/Home/presentation/widgets/calender_widget.dart';

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
            PointsWidget(),
            AppConstants.defaultSpace,
            HabitsNGoalsWidget(),
            AppConstants.defaultSpace,
            Text(
              '  Today',
              style: TypographyTheme.simpleTitleStyle(fontSize: 13),
            ),
            AppConstants.defaultSpace,

            // Container(
            //   height: 140,
            //   width: double.maxFinite,
            //   decoration: BoxDecoration(
            //     color: AppColors.xtraLightGreyColor,
            //     borderRadius: AppConstants.widgetBorderRadius,
            //   ),
            //   child: Center(
            //     child: Text(
            //       'No Pending Tasks & Habits to \n complete Today!',
            //       textAlign: TextAlign.center,
            //       style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
            //     ),
            //   ),
            // ),
            Container(
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
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: AppConstants.widgetMediumBorderRadius,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You have 2 tasks pending',
                          style: TypographyTheme.simpleTitleStyle(fontSize: 14),
                        ),

                        Text(
                          textAlign: TextAlign.center,
                          'Complete Now',
                          style: TypographyTheme.simpleSubTitleStyle(
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
            AppConstants.defaultSpace,
            Container(
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
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: AppConstants.widgetMediumBorderRadius,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3 Habits Needs Action',
                          style: TypographyTheme.simpleTitleStyle(fontSize: 14),
                        ),

                        Text(
                          textAlign: TextAlign.center,
                          'Get Started Now',
                          style: TypographyTheme.simpleSubTitleStyle(
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
              child: Container(
                height: double.maxFinite,
                padding: EdgeInsets.all(AppConstants.kMediumPadding),
                decoration: BoxDecoration(
                  borderRadius: AppConstants.widgetBorderRadius,
                  color: AppColors.themeWhite,
                  border: Border.all(color: AppColors.lightGreyColor),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          textAlign: TextAlign.start,
                          '13',
                          style: TypographyTheme.simpleTitleStyle(fontSize: 16),
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
                      'Good Habits',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
                    ),
                    AppConstants.defaultSpace,
                    SizedBox(
                      height: 65,
                      width: double.maxFinite,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 6,
                            color: AppColors.lightGreyColor,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            HugeIcons.strokeRoundedLeaf01,
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
          ),
          AppConstants.singleWidth,
          Expanded(
            child: Container(
              height: double.maxFinite,
              padding: EdgeInsets.all(AppConstants.kMediumPadding),
              decoration: BoxDecoration(
                borderRadius: AppConstants.widgetBorderRadius,
                color: AppColors.themeWhite,
                border: Border.all(color: AppColors.lightGreyColor),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        '04',
                        style: TypographyTheme.simpleTitleStyle(fontSize: 16),
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
                    'Bad Habits',
                    style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
                  ),
                  AppConstants.defaultSpace,
                  SizedBox(
                    height: 65,
                    width: double.maxFinite,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 6,
                          color: AppColors.lightGreyColor,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          HugeIcons.strokeRoundedCancel01,
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
          AppConstants.singleWidth,
          Expanded(
            child: InkWell(
              onTap: () {
                context.pushNamed(RouteConstants.tasksPageName);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: Hive.box(
                        HiveConstants.unitValuesBox,
                      ).listenable(),
                      builder: (context, pendingCountBox, child) {
                        final pendingTasksCount =
                            pendingCountBox.get(
                              HiveConstants.pendingTaskCount,
                            ) ??
                            0;
                        final completedTasksCount =
                            pendingCountBox.get(
                              HiveConstants.completedTaskCount,
                            ) ??
                            0;
                        return Row(
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
                        );
                      },
                    ),

                    Text(
                      textAlign: TextAlign.start,
                      'Goals',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
                    ),
                    AppConstants.defaultSpace,
                    SizedBox(
                      height: 65,
                      width: double.maxFinite,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 6,
                            color: AppColors.lightGreyColor,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            HugeIcons.strokeRoundedTask01,
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
          ),
        ],
      ),
    );
  }
}

class PointsWidget extends StatelessWidget {
  const PointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 113,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                context.pushNamed(RouteConstants.paywallPageName);
              },
              child: Container(
                padding: AppConstants.widgetInternalPadding,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGreyColor),
                  color: AppColors.themeWhite,
                  borderRadius: AppConstants.widgetBorderRadius,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            HugeIcons.strokeRoundedMedal02,
                            color: AppColors.themeBlack,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            '735 Xp',
                            style: TypographyTheme.simpleTitleStyle(
                              fontSize: 15,
                            ),
                          ),

                          Text(
                            textAlign: TextAlign.start,
                            'Points Earned',
                            style: TypographyTheme.simpleSubTitleStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppConstants.singleWidth,
          Expanded(
            child: Container(
              padding: AppConstants.widgetInternalPadding,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGreyColor),
                color: AppColors.themeWhite,
                borderRadius: AppConstants.widgetBorderRadius,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          HugeIcons.strokeRoundedMedalFirstPlace,
                          color: AppColors.themeBlack,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              textAlign: TextAlign.start,
                              'level 1',
                              style: TypographyTheme.simpleTitleStyle(
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.start,
                              '45%',
                              style: TypographyTheme.simpleSubTitleStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
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
            ),
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
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: AppConstants.widgetMediumBorderRadius,
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.rocket_fill,
                color: AppColors.themeBlack,
                size: 20,
              ),
            ),
          ),
          AppConstants.singleWidth,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.center,
                '"I am Software Engineer"',
                style: TypographyTheme.simpleTitleStyle(
                  fontSize: 15,
                ).copyWith(fontStyle: FontStyle.italic),
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
