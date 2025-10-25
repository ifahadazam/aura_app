import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/services/form_validation/validations/required_validation.dart';
import 'package:life_goal/core/services/form_validation/validator.dart';
import 'package:life_goal/core/shared/buttons/action_button.dart';
import 'package:life_goal/core/shared/buttons/icon_tap_button.dart';
import 'package:life_goal/core/shared/custom_text_field.dart';
import 'package:life_goal/features/goals/data/models/tasks_model.dart';
import 'package:life_goal/features/goals/data/services/task_service.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode notesFocusNode = FocusNode();
  final ValueNotifier<String> taskPriority = ValueNotifier('High');
  final ValueNotifier<bool> isReminderEnabled = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();
  String selectedDate = '';
  String selectedTime = '';

  @override
  void dispose() {
    super.dispose();
    taskPriority.dispose();
    titleController.dispose();
    notesController.dispose();
    isReminderEnabled.dispose();
    titleFocusNode.dispose();
    notesFocusNode.dispose();
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = DateFormat('d-MMM-yyyy').format(date);
      });
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time.format(context); // e.g. 5:30 PM
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        titleFocusNode.unfocus();
        notesFocusNode.unfocus();
      },
      child: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kLargePadding,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create a Task',
                      style: TypographyTheme.simpleTitleStyle(fontSize: 18),
                    ),
                    IconTapButton(
                      onTap: () {
                        context.pop();
                      },
                      iconDta: Icons.close_rounded,
                      iconSize: 24,
                      iconColor: AppColors.redColor,
                    ),
                  ],
                ),
                AppConstants.defaultSpace,
                // AppConstants.defaultDoubleSpace,
                Text(
                  ' Task Title',
                  style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                ),
                AppConstants.defaultSpace,
                TextInputField(
                  themeColor: AppColors.lightBlackColor,
                  focusNode: titleFocusNode,
                  textController: titleController,
                  hintText: 'What\'s your task',
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  validator: Validator.apply(context, [RequiredValidation()]),
                ),
                AppConstants.defaultDoubleSpace,
                Text(
                  ' Notes (Optional)',
                  style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                ),
                AppConstants.defaultSpace,
                TextInputField(
                  themeColor: AppColors.lightBlackColor,
                  focusNode: notesFocusNode,
                  maxLines: 2,
                  textController: TextEditingController(),
                  hintText: 'Add additional notes here..',
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  // validator: Validator.apply(context, [RequiredValidation()]),
                ),

                AppConstants.defaultDoubleSpace,
                Text(
                  ' Priority',
                  style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                ),
                AppConstants.defaultSpace,
                ValueListenableBuilder(
                  valueListenable: taskPriority,
                  builder: (context, isPriorityHigh, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            taskPriority.value = 'High';
                          },
                          child: PriorityButton(
                            title: 'High',
                            isPriorityHigh: isPriorityHigh == 'High',
                          ),
                        ),
                        AppConstants.singleWidth,
                        InkWell(
                          onTap: () {
                            taskPriority.value = 'Low';
                          },
                          child: PriorityButton(
                            title: 'Low',
                            isPriorityHigh: isPriorityHigh == 'Low',
                          ),
                        ),
                      ],
                    );
                  },
                ),

                AppConstants.defaultDoubleSpace,
                Text(
                  ' Choose Date & Time',
                  style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                ),
                AppConstants.defaultSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        pickDate();
                      },
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.kLargePadding,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.transparentColor,
                          border: Border.all(color: AppColors.lightBlackColor),
                          borderRadius: AppConstants.widetHalfBorderRadius,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: AppColors.themeBlack,
                              size: 20,
                            ),
                            AppConstants.halfWidth,
                            Text(
                              selectedDate == '' ? 'Select Date' : selectedDate,
                              style: TypographyTheme.simpleSubTitleStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppConstants.singleWidth,
                    InkWell(
                      onTap: () {
                        pickTime();
                      },
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.kLargePadding,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.transparentColor,
                          border: Border.all(color: AppColors.lightBlackColor),
                          borderRadius: AppConstants.widetHalfBorderRadius,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.watch_later_rounded,
                              color: AppColors.themeBlack,
                              size: 20,
                            ),
                            AppConstants.halfWidth,
                            Text(
                              selectedTime == '' ? 'Select Time' : selectedTime,
                              style: TypographyTheme.simpleSubTitleStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AppConstants.defaultDoubleSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' Set a reminder for this task',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                    ),
                    ValueListenableBuilder(
                      valueListenable: isReminderEnabled,
                      builder: (context, isEnabled, child) {
                        return Switch.adaptive(
                          value: isEnabled,
                          onChanged: (val) {
                            isReminderEnabled.value = val;
                          },
                          activeColor: AppColors.themeWhite,
                          activeTrackColor: AppColors.themeBlack,
                          inactiveThumbColor: AppColors.greyColor,
                          inactiveTrackColor: AppColors.xtraLightGreyColor,
                        );
                      },
                    ),
                  ],
                ),
                Spacer(),
                ActionButton(
                  onTap: () {
                    final taskService = TaskService();
                    if (formKey.currentState!.validate()) {
                      final taskPriorityValue = taskPriority.value;
                      log('The Date: $selectedDate');
                      final task = TasksModel(
                        title: titleController.text.trim(),
                        notes: notesController.text.trim(),
                        taskPriority: taskPriorityValue,
                        taskDate: selectedDate,
                        taskTime: selectedTime,
                        isSetEnabled: isReminderEnabled.value,
                        isTaskDone: false,
                        taskKey: DateTime.now().toString(),
                      );
                      taskService.addTask(task).whenComplete(() {
                        taskService.savePendingTasksCount();
                        if (context.mounted) {
                          context.pop();
                        }
                      });
                    }
                  },
                  title: 'Add Task',
                  buttonColor: AppColors.themeBlack,
                ),
                AppConstants.defaultSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PriorityButton extends StatelessWidget {
  const PriorityButton({
    super.key,
    required this.isPriorityHigh,
    required this.title,
  });
  final bool isPriorityHigh;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: AppConstants.kLargePadding),
      decoration: BoxDecoration(
        color: isPriorityHigh
            ? AppColors.themeBlack
            : AppColors.xtraLightGreyColor,
        borderRadius: AppConstants.widetHalfBorderRadius,
      ),
      child: Center(
        child: Text(
          title,
          style: TypographyTheme.simpleSubTitleStyle(fontSize: 13).copyWith(
            color: isPriorityHigh ? AppColors.themeWhite : AppColors.themeBlack,
          ),
        ),
      ),
    );
  }
}
