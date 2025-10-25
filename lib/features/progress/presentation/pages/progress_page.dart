import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
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
            LevelNPointsWidget(),
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
              valueListenable: switchGraph,
              builder: (context, isSwitched, child) {
                return AspectRatio(
                  aspectRatio: 1.50,
                  child: Container(
                    padding: AppConstants.widgetInternalPadding,
                    decoration: BoxDecoration(
                      color: AppColors.themeWhite,
                      borderRadius: AppConstants.widgetBorderRadius,
                      border: Border.all(color: AppColors.lightGreyColor),
                    ),
                    child: isSwitched ? MonthlyLineChart() : WeeklyBarGraph(),
                  ),
                );
              },
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
                child: Center(child: Icon(HugeIcons.strokeRoundedGridView)),
              ),
              AppConstants.singleWidth,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Habits',
                    style: TypographyTheme.simpleTitleStyle(fontSize: 16),
                  ),
                  Text(
                    'Summary',
                    style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.xtraLightGreyColor,
                  borderRadius: AppConstants.widgetMediumBorderRadius,
                ),
                child: Center(child: Icon(Icons.keyboard_arrow_down_rounded)),
              ),
            ],
          ),
          AppConstants.defaultSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: AppConstants.kMediumPadding),
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
                              '53',
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
                              '17',
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
                              '46',
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
                              '07',
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
                              '24',
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
                              '77%',
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
