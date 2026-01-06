import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/shared/internal_page_app_bar.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';

const allWeekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const weekDaysNumber = [1, 2, 3, 4, 5, 6, 7];

class DailyReminderPage extends StatefulWidget {
  const DailyReminderPage({
    super.key,
    required this.reminderDays,
    required this.reminderTime,
  });
  final List<int> reminderDays;
  final String reminderTime;

  @override
  State<DailyReminderPage> createState() => _DailyReminderPageState();
}

class _DailyReminderPageState extends State<DailyReminderPage> {
  // final List<int> selectedDays = [];
  String selectedTime = '';
  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null && mounted) {
      selectedTime = time.format(context);
      await Hive.box(
        HiveConstants.temporaryBuffer,
      ).put(HiveConstants.reminderTime, selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamyWhiteColor,
      appBar: InternalPageAppBar(
        title: 'Set Reminder',
        themeColor: AppColors.themeBlack,
      ),
      body: Padding(
        padding: AppConstants.pagesInternalPadding,
        child: ValueListenableBuilder(
          valueListenable: Hive.box(HiveConstants.temporaryBuffer).listenable(),
          builder: (context, reminderBox, child) {
            final List<int> selectedDays =
                reminderBox.get(HiveConstants.reminderDays) ??
                widget.reminderDays;
            final String time =
                reminderBox.get(HiveConstants.reminderTime) ??
                widget.reminderTime;
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '  Days',
                    style: TypographyTheme.simpleTitleStyle(fontSize: 11),
                  ),
                ),
                AppConstants.defualtHalfSpace,
                SizedBox(
                  height: 40,
                  width: double.maxFinite,
                  child: Row(
                    spacing: 4,
                    children: List.generate(weekDaysNumber.length, (index) {
                      return EachDay(
                        isSelected: selectedDays.contains(index + 1),
                        title: allWeekDays[index],
                        onTap: () async {
                          if (selectedDays.contains(weekDaysNumber[index])) {
                            selectedDays.remove(weekDaysNumber[index]);
                            await Hive.box(
                              HiveConstants.temporaryBuffer,
                            ).put(HiveConstants.reminderDays, selectedDays);
                            log('SL:$selectedDays');
                            setState(() {});
                          } else {
                            selectedDays.add(weekDaysNumber[index]);
                            await Hive.box(
                              HiveConstants.temporaryBuffer,
                            ).put(HiveConstants.reminderDays, selectedDays);

                            log('SL:$selectedDays');
                            setState(() {});
                          }
                        },
                      );
                    }),
                  ),
                ),
                AppConstants.defaultDoubleSpace,
                SizedBox(
                  height: 60,
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Pick Time',
                        style: TypographyTheme.simpleSubTitleStyle(
                          fontSize: 12,
                        ),
                      ),
                      AppConstants.defualtHalfSpace,
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (selectedDays.isNotEmpty) {
                              pickTime();
                            }
                          },
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  time == '' ? ' 12:00' : time,
                                  style:
                                      TypographyTheme.simpleTitleStyle(
                                        fontSize: 12,
                                      ).copyWith(
                                        color: selectedDays.isEmpty
                                            ? AppColors.greyColor
                                            : AppColors.themeBlack,
                                      ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 17,
                                  color: AppColors.themeBlack,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class EachDay extends StatelessWidget {
  const EachDay({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // padding: EdgeInsets.symmetric(
          //   horizontal: AppConstants.kMediumPadding,
          //   vertical: AppConstants.kSmallPadding,
          // ),
          decoration: BoxDecoration(
            borderRadius: AppConstants.widetHalfBorderRadius,
            color: isSelected
                ? AppColors.themeBlack
                : AppColors.xtraLightGreyColor,
          ),
          child: Center(
            child: Text(
              title,
              style: TypographyTheme.simpleSubTitleStyle(fontSize: 12).copyWith(
                color: isSelected ? AppColors.themeWhite : AppColors.themeBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
