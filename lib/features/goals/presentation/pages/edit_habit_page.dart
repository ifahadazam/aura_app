import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/services/form_validation/validations/required_validation.dart';
import 'package:life_goal/core/services/form_validation/validator.dart';
import 'package:life_goal/core/shared/buttons/action_button.dart';
import 'package:life_goal/core/shared/custom_text_field.dart';
import 'package:life_goal/core/shared/internal_page_app_bar.dart';
import 'package:life_goal/core/utils/hive_db/hive_constants.dart';
import 'package:life_goal/features/goals/data/models/habit_model.dart';
import 'package:life_goal/features/goals/data/services/task_service.dart';
import 'package:life_goal/features/goals/presentation/pages/create_habit.dart';
import 'package:life_goal/features/goals/presentation/pages/daily_reminder_page.dart';

class EditHabitPage extends StatefulWidget {
  const EditHabitPage({super.key, required this.habit});
  final HabitModel habit;

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController titleController;
  late final TextEditingController notesController;
  late TabController _tabController;
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode notesFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  int habitColorIndex = 0;

  final ValueNotifier<int?> selectedColor = ValueNotifier<int?>(null);
  final ValueNotifier showMoreOptions = ValueNotifier<bool>(false);
  final ValueNotifier<bool?> isValueCustom = ValueNotifier<bool?>(null);

  // final ValueNotifier showMoreOptions = ValueNotifier<bool>(false);
  // final ValueNotifier isValueCustom = ValueNotifier<bool>(false);
  // final formKey = GlobalKey<FormState>();
  // final ValueNotifier selectedColor = ValueNotifier<Color>(Colors.yellow);

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.habit.title);
    notesController = TextEditingController(text: widget.habit.description);
    habitColorIndex = widget.habit.habitColor;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.habit.valueCount == 0
          ? 0
          : 1, // 👈 Start from 3rd tab
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    notesController.dispose();
    titleFocusNode.dispose();
    notesFocusNode.dispose();
    Hive.box(HiveConstants.temporaryBuffer).clear();
    // habitType.dispose();
    // showMoreOptions.dispose();
    // isValueCustom.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.creamyWhiteColor,
      appBar: InternalPageAppBar(
        title: 'Edit Habit',
        themeColor: AppColors.themeBlack,
      ),
      body: Padding(
        padding: AppConstants.pagesInternalPadding,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' Task Title',
                  style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                ),
                AppConstants.defaultSpace,
                TextInputField(
                  themeColor: AppColors.themeBlack.withAlpha(200),

                  textController: titleController,
                  focusNode: titleFocusNode,
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
                  themeColor: AppColors.themeBlack.withAlpha(200),
                  // maxLines: 2,
                  textController: notesController,
                  focusNode: notesFocusNode,
                  hintText: 'Add additional notes here..',
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                AppConstants.defaultDoubleSpace,

                //* Editable Values are temporarily stored and retreived from Hive Box named "Tenporary Buffer"
                ValueListenableBuilder(
                  valueListenable: Hive.box(
                    HiveConstants.temporaryBuffer,
                  ).listenable(),
                  builder: (context, tempBox, child) {
                    final streakGoal =
                        tempBox.get('streak_goal') ?? widget.habit.streakGoal;

                    final valueDigit =
                        tempBox.get('custom_val') ?? widget.habit.valueCount;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' Choose Color',
                              style: TypographyTheme.simpleSubTitleStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        AppConstants.defaultSpace,
                        SizedBox(
                          height: 35,
                          width: double.maxFinite,
                          child: Row(
                            spacing: 12,
                            children: List.generate(colorRow.length, (index) {
                              return Expanded(
                                child: ValueListenableBuilder(
                                  valueListenable: selectedColor,
                                  builder: (context, choosenColor, child) {
                                    final bool isColorSelected =
                                        (choosenColor ?? habitColorIndex) ==
                                        index;
                                    return GestureDetector(
                                      onTap: () {
                                        selectedColor.value = index;
                                      },
                                      child: index == colorRow.length - 1
                                          ? GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  backgroundColor: AppColors
                                                      .creamyWhiteColor,
                                                  showDragHandle: true,

                                                  context: context,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      width: double.maxFinite,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                          AppConstants
                                                              .kMediumPadding,
                                                        ),
                                                        child: Wrap(
                                                          spacing: 12,
                                                          runSpacing: 12,

                                                          children: List.generate(
                                                            selectableColors
                                                                .length,
                                                            (index) {
                                                              return ValueListenableBuilder(
                                                                valueListenable:
                                                                    selectedColor,
                                                                builder:
                                                                    (
                                                                      context,
                                                                      choosenColor,
                                                                      child,
                                                                    ) {
                                                                      final bool
                                                                      isColorSelected =
                                                                          choosenColor ==
                                                                          index;
                                                                      return GestureDetector(
                                                                        onTap: () {
                                                                          selectedColor.value =
                                                                              index;
                                                                        },
                                                                        child: Container(
                                                                          height:
                                                                              35,
                                                                          width:
                                                                              35,
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                              color: isColorSelected
                                                                                  ? AppColors.lightBlackColor
                                                                                  : AppColors.greyColor,
                                                                            ),
                                                                            color:
                                                                                selectableColors[index],
                                                                            borderRadius: BorderRadius.circular(
                                                                              6,
                                                                            ),
                                                                          ),

                                                                          child:
                                                                              isColorSelected
                                                                              ? Center(
                                                                                  child: Icon(
                                                                                    Icons.circle,
                                                                                    size: 12,
                                                                                    color: AppColors.themeBlack,
                                                                                  ),
                                                                                )
                                                                              : null,
                                                                        ),
                                                                      );
                                                                    },
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_right_rounded,
                                                color: AppColors.themeBlack,
                                                size: 26,
                                              ),
                                            )
                                          : Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: isColorSelected
                                                      ? AppColors
                                                            .lightBlackColor
                                                      : AppColors.greyColor,
                                                ),
                                                color: colorRow[index],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),

                                              child: isColorSelected
                                                  ? Center(
                                                      child: Icon(
                                                        Icons.circle,
                                                        size: 12,
                                                        color: AppColors
                                                            .themeBlack,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ),

                        AppConstants.defaultDoubleSpace,
                        ValueListenableBuilder(
                          valueListenable: showMoreOptions,
                          builder: (context, isOptionsShown, child) {
                            return Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  InkWell(
                                    splashColor: AppColors.transparentColor,
                                    onTap: () {
                                      showMoreOptions.value = !isOptionsShown;
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ' More Options ',
                                          style:
                                              TypographyTheme.simpleSubTitleStyle(
                                                fontSize: 13,
                                              ).copyWith(
                                                color: AppColors.lightBlackColor
                                                    .withAlpha(220),
                                              ),
                                        ),
                                        Icon(
                                          isOptionsShown
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons
                                                    .keyboard_arrow_down_rounded,
                                          color: AppColors.themeBlack.withAlpha(
                                            220,
                                          ),
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),

                                  AppConstants.defaultDoubleSpace,

                                  if (isOptionsShown)
                                    SizedBox(
                                      width: double.maxFinite,
                                      height: 63,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

                                              children: [
                                                Text(
                                                  ' Streak Goal (Days)',
                                                  style:
                                                      TypographyTheme.simpleSubTitleStyle(
                                                        fontSize: 12,
                                                      ),
                                                ),
                                                AppConstants.defualtHalfSpace,
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return EditStreakGoal(
                                                          habit: widget.habit,
                                                          tempBox: tempBox,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              AppConstants
                                                                  .kSmallPadding,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: AppConstants
                                                          .widetHalfBorderRadius,
                                                      color:
                                                          AppColors.themeWhite,
                                                      border: Border.all(
                                                        color: AppColors
                                                            .lightGreyColor,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          streakGoal == 0
                                                              ? ' None'
                                                              : '${streakGoal.toString()} Days',
                                                          style:
                                                              TypographyTheme.simpleTitleStyle(
                                                                fontSize: 12,
                                                              ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 17,
                                                          color: AppColors
                                                              .themeBlack,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          AppConstants.singleWidth,
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  ' Reminder',
                                                  style:
                                                      TypographyTheme.simpleSubTitleStyle(
                                                        fontSize: 12,
                                                      ),
                                                ),
                                                AppConstants.defualtHalfSpace,
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            DailyReminderPage(),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              AppConstants
                                                                  .kSmallPadding,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: AppConstants
                                                          .widetHalfBorderRadius,
                                                      color:
                                                          AppColors.themeWhite,
                                                      border: Border.all(
                                                        color: AppColors
                                                            .lightGreyColor,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ValueListenableBuilder(
                                                          valueListenable: Hive.box(
                                                            HiveConstants
                                                                .temporaryBuffer,
                                                          ).listenable(),
                                                          builder:
                                                              (
                                                                context,
                                                                reminderBox,
                                                                child,
                                                              ) {
                                                                final reminderTime =
                                                                    reminderBox.get(
                                                                      HiveConstants
                                                                          .reminderTime,
                                                                    ) ??
                                                                    'None';
                                                                return Text(
                                                                  ' $reminderTime',
                                                                  style:
                                                                      TypographyTheme.simpleTitleStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                );
                                                              },
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 17,
                                                          color: AppColors
                                                              .themeBlack,
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

                                  if (isOptionsShown)
                                    AppConstants.defaultDoubleSpace,
                                  if (isOptionsShown)
                                    ValueListenableBuilder(
                                      valueListenable: isValueCustom,
                                      builder: (context, isValueTypwCustom, chils) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  Value Type',
                                              style:
                                                  TypographyTheme.simpleSubTitleStyle(
                                                    fontSize: 12,
                                                  ),
                                            ),
                                            AppConstants.defualtHalfSpace,
                                            Container(
                                              height: 35,
                                              width: double.maxFinite,
                                              decoration: BoxDecoration(
                                                borderRadius: AppConstants
                                                    .widetHalfBorderRadius,
                                                color: AppColors.themeWhite,
                                                border: Border.all(
                                                  color:
                                                      AppColors.lightGreyColor,
                                                ),
                                              ),
                                              child: TabBar(
                                                controller: _tabController,
                                                onTap: (val) {
                                                  if (val == 0) {
                                                    isValueCustom.value = false;
                                                  } else {
                                                    isValueCustom.value = true;
                                                  }
                                                },
                                                labelColor:
                                                    AppColors.themeWhite,
                                                unselectedLabelColor:
                                                    AppColors.lightBlackColor,
                                                labelStyle:
                                                    TypographyTheme.simpleTitleStyle(
                                                      fontSize: 13,
                                                    ),
                                                dividerColor:
                                                    Colors.transparent,
                                                indicatorSize:
                                                    TabBarIndicatorSize.tab,
                                                indicator: BoxDecoration(
                                                  // color: AppColors.prominentColor3,
                                                  color: AppColors.themeBlack,
                                                  borderRadius: AppConstants
                                                      .widetHalfBorderRadius,
                                                ),
                                                tabs: [
                                                  Tab(text: 'Yes / No'),
                                                  Tab(text: 'Custom'),
                                                ],
                                              ),
                                            ),
                                            AppConstants.defaultDoubleSpace,
                                            if (isValueTypwCustom ??
                                                widget.habit.valueCount > 0)
                                              SizedBox(
                                                height: 60,
                                                width: double.maxFinite,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            ' Custom Value',
                                                            style:
                                                                TypographyTheme.simpleSubTitleStyle(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                          AppConstants
                                                              .defualtHalfSpace,
                                                          Expanded(
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    AppConstants
                                                                        .kSmallPadding,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    AppConstants
                                                                        .widetHalfBorderRadius,
                                                                color: AppColors
                                                                    .themeWhite,
                                                                border: Border.all(
                                                                  color: AppColors
                                                                      .lightGreyColor,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    ' $valueDigit',
                                                                    style: TypographyTheme.simpleTitleStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    ' / Day',
                                                                    style: TypographyTheme.simpleSubTitleStyle(
                                                                      fontSize:
                                                                          14,
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
                                                      flex: 2,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '',
                                                            style:
                                                                TypographyTheme.simpleSubTitleStyle(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                          AppConstants
                                                              .defualtHalfSpace,

                                                          Expanded(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    AppConstants
                                                                        .widetHalfBorderRadius,
                                                                color: AppColors
                                                                    .themeWhite,
                                                                border: Border.all(
                                                                  color: AppColors
                                                                      .lightGreyColor,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: GestureDetector(
                                                                      onTap: () async {
                                                                        final int
                                                                        newVal =
                                                                            valueDigit ==
                                                                                1
                                                                            ? 1
                                                                            : valueDigit -
                                                                                  1;
                                                                        await Hive.box(
                                                                          HiveConstants
                                                                              .temporaryBuffer,
                                                                        ).put(
                                                                          'custom_val',
                                                                          newVal,
                                                                        );
                                                                      },
                                                                      child: SizedBox(
                                                                        child: Center(
                                                                          child: Icon(
                                                                            CupertinoIcons.minus,
                                                                            color:
                                                                                AppColors.themeBlack,
                                                                            size:
                                                                                22,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(
                                                                    width: 2,
                                                                    color: AppColors
                                                                        .greyColor,
                                                                  ),
                                                                  Expanded(
                                                                    child: InkWell(
                                                                      onTap: () async {
                                                                        final int
                                                                        newVal =
                                                                            valueDigit +
                                                                            1;
                                                                        await Hive.box(
                                                                          HiveConstants
                                                                              .temporaryBuffer,
                                                                        ).put(
                                                                          'custom_val',
                                                                          newVal,
                                                                        );
                                                                      },
                                                                      child: SizedBox(
                                                                        child: Center(
                                                                          child: Icon(
                                                                            CupertinoIcons.add,
                                                                            color:
                                                                                AppColors.themeBlack,
                                                                            size:
                                                                                22,
                                                                          ),
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
                                                    AppConstants.singleWidth,
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '',
                                                            style:
                                                                TypographyTheme.simpleSubTitleStyle(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                          AppConstants
                                                              .defualtHalfSpace,
                                                          Expanded(
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (context) {
                                                                    return EditCustomHabitValue(
                                                                      habitValue: widget
                                                                          .habit
                                                                          .habitValue
                                                                          .toString(),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      AppConstants
                                                                          .widetHalfBorderRadius,
                                                                  color: AppColors
                                                                      .themeWhite,
                                                                  border: Border.all(
                                                                    color: AppColors
                                                                        .lightGreyColor,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: AppColors
                                                                        .themeBlack,
                                                                    size: 22,
                                                                  ),
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
                                          ],
                                        );
                                      },
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: AppConstants.kMediumPadding,
          right: AppConstants.kMediumPadding,
          bottom: AppConstants.kSmallPadding,
        ),
        child: SizedBox(
          height: 45,
          width: double.maxFinite,
          child: ActionButton(
            onTap: () async {
              final taskService = TaskService();
              if (formKey.currentState!.validate() && context.mounted) {
                final title = titleController.text.trim();
                final subTitle = notesController.text.trim();

                final streakDays =
                    Hive.box(
                      HiveConstants.temporaryBuffer,
                    ).get('streak_goal') ??
                    widget.habit.streakGoal;
                final theHabitKey = widget.habit.habitKey;

                log('The Habit Key aferUpdate: $theHabitKey');
                // final isHabitValueCustom = isValueCustom.value ? 1 : 0;
                final updatedHabit = HabitModel(
                  title: title,
                  description: subTitle,
                  habitValue: widget.habit.habitValue,
                  valueCount: widget.habit.valueCount,
                  streakGoal: streakDays,
                  isDone: widget.habit.isDone,
                  reminderDays: widget.habit.reminderDays,
                  reminderTime: widget.habit.reminderTime,
                  habitColor: widget.habit.habitColor,
                  habitKey: theHabitKey,
                );

                await taskService.addNewHabit(updatedHabit);

                if (context.mounted) {
                  context.pop();
                }
              }
            },
            title: 'Update',
            buttonColor: AppColors.themeBlack,
          ),
        ),
      ),
    );
  }
}

class EditStreakGoal extends StatefulWidget {
  const EditStreakGoal({super.key, required this.habit, required this.tempBox});
  final HabitModel habit;
  final Box<dynamic> tempBox;

  @override
  State<EditStreakGoal> createState() => _EditStreakGoalState();
}

class _EditStreakGoalState extends State<EditStreakGoal> {
  late final TextEditingController controller;

  @override
  void initState() {
    final previousStreak =
        widget.tempBox.get('streak_goal') ?? widget.habit.streakGoal.toString();
    controller = TextEditingController(text: previousStreak);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.creamyWhiteColor,
      icon: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: AppColors.xtraLightGreyColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            CupertinoIcons.flame_fill,
            color: AppColors.mainColorStrongOrange,
            size: 26,
          ),
        ),
      ),
      title: Text(
        'Streak Goal',
        style: TypographyTheme.simpleTitleStyle(fontSize: 16),
      ),
      content: TextInputField(
        isBorderVisible: false,
        textController: controller,
        hintText: 'Enter in Days',
        obscureText: false,
        keyboardType: TextInputType.number,
        themeColor: AppColors.themeBlack,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            'Cancel',
            style: TypographyTheme.simpleTitleStyle(fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.tempBox.put('streak_goal', controller.text.trim());
            context.pop();
          },
          child: Text(
            'Save',
            style: TypographyTheme.simpleTitleStyle(
              fontSize: 14,
            ).copyWith(color: AppColors.greenColor),
          ),
        ),
      ],
    );
  }
}

class EditCustomHabitValue extends StatefulWidget {
  const EditCustomHabitValue({super.key, required this.habitValue});
  final String habitValue;

  @override
  State<EditCustomHabitValue> createState() => _EditCustomHabitValueState();
}

class _EditCustomHabitValueState extends State<EditCustomHabitValue> {
  late final TextEditingController controller;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.habitValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.creamyWhiteColor,

      title: Text(
        'Custom Value',
        style: TypographyTheme.simpleTitleStyle(fontSize: 16),
      ),
      content: TextInputField(
        isBorderVisible: false,
        textController: controller,
        hintText: 'Enter in numbers',
        obscureText: false,
        keyboardType: TextInputType.number,
        themeColor: AppColors.themeBlack,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            'Cancel',
            style: TypographyTheme.simpleTitleStyle(fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: () {
            Hive.box(
              HiveConstants.temporaryBuffer,
            ).put(HiveConstants.valueType, int.parse(controller.text.trim()));
            context.pop();
          },
          child: Text(
            'Save',
            style: TypographyTheme.simpleTitleStyle(
              fontSize: 14,
            ).copyWith(color: AppColors.greenColor),
          ),
        ),
      ],
    );
  }
}
