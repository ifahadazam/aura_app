import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/extensions/sized_box.dart';
import 'package:life_goal/core/utils/date_util/week_days_n_date.dart';
import 'package:life_goal/features/home/presentation/widgets/date_n_day.dart';

class CalenderWidget extends StatelessWidget {
  const CalenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(
      //   horizontal: AppConstants.kSmallPadding,
      // ),
      // padding: AppConstants.widgetInternalPadding,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.transparentColor,
        borderRadius: AppConstants.widgetBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Text(
          //       ' ${WeekDaysNDate.currentMoth()}',
          //       style: TypographyTheme.simpleTitleStyle(fontSize: 32),
          //     ),
          //     const Spacer(),
          //     Container(
          //       height: 28,

          //       padding: EdgeInsets.symmetric(
          //         horizontal: AppConstants.kSmallPadding,
          //       ),
          //       decoration: BoxDecoration(
          //         color: const Color.fromARGB(255, 245, 244, 244),
          //         borderRadius: AppConstants.widgetBorderRadius,
          //       ),
          //       child: Center(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Image(
          //               height: 15,
          //               width: 15,
          //               image: AssetImage('assets/images/streak_icon.png'),
          //             ),
          //             2.width,
          //             Text(
          //               '17',
          //               style: TypographyTheme.simpleSubTitleStyle(
          //                 fontSize: 12,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // AppConstants.defaultSpace,
          SizedBox(
            height: 80,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                List<Map<String, dynamic>> weekDates =
                    WeekDaysNDate.getWeekDates();
                final weekDay = weekDates[index]['weekDay']!.substring(0, 3);
                final day = weekDates[index]['day'];
                final bool isToday = weekDates[index]['isToday'];
                return DateNDay(
                  weekDay: weekDay ?? 'Mon',
                  date: day ?? '12',
                  isToday: isToday,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
