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
import 'package:life_goal/features/goals/presentation/pages/create_task.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key, required this.task});
  final TasksModel task;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late final TextEditingController titleController;
  late final TextEditingController notesController;
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode notesFocusNode = FocusNode();
  String? taskPriority;
  bool? isReminderEnabled;
  final formKey = GlobalKey<FormState>();
  String selectedDate = '';
  String selectedTime = '';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    notesController = TextEditingController(text: widget.task.notes);
  }

  @override
  void dispose() {
    super.dispose();

    titleController.dispose();
    notesController.dispose();
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
    return SizedBox(
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
                maxLines: 2,
                textController: notesController,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        taskPriority = 'High';
                      });
                    },
                    child: PriorityButton(
                      title: 'High',
                      isPriorityHigh: taskPriority == null
                          ? widget.task.taskPriority == 'High'
                          : taskPriority == 'High',
                    ),
                  ),

                  AppConstants.singleWidth,
                  InkWell(
                    onTap: () {
                      setState(() {
                        taskPriority = 'Low';
                      });
                    },
                    child: PriorityButton(
                      title: 'Low',
                      isPriorityHigh: taskPriority == null
                          ? widget.task.taskPriority == 'Low'
                          : taskPriority == 'Low',
                    ),
                  ),
                ],
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
                            selectedDate == ''
                                ? widget.task.taskDate
                                : selectedDate,
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
                            selectedTime == ''
                                ? widget.task.taskTime
                                : selectedTime,
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
                  Switch.adaptive(
                    value: isReminderEnabled ?? widget.task.isSetEnabled,
                    onChanged: (val) {
                      setState(() {
                        isReminderEnabled = val;
                      });
                    },
                    activeColor: AppColors.themeWhite,
                    activeTrackColor: AppColors.themeBlack,
                    inactiveThumbColor: AppColors.greyColor,
                    inactiveTrackColor: AppColors.xtraLightGreyColor,
                  ),
                ],
              ),
              Spacer(),
              ActionButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    final taskPriorityValue =
                        taskPriority ?? widget.task.taskPriority;
                    final task = TasksModel(
                      title: titleController.text.trim(),
                      notes: notesController.text.trim(),
                      taskPriority: taskPriorityValue,
                      taskDate: selectedDate == ''
                          ? widget.task.taskDate
                          : selectedDate,
                      taskTime: selectedTime == ''
                          ? widget.task.taskTime
                          : selectedTime,
                      isSetEnabled:
                          isReminderEnabled ?? widget.task.isSetEnabled,
                      isTaskDone: false,
                      taskKey: widget.task.taskKey,
                    );
                    TaskService().addTask(task).whenComplete(() {
                      log('Task ${task.taskDate}');
                      if (context.mounted) {
                        context.pop();
                      }
                    });
                  }
                },
                title: 'Save',
                buttonColor: AppColors.themeBlack,
              ),
              AppConstants.defaultSpace,
            ],
          ),
        ),
      ),
    );
  }
}
