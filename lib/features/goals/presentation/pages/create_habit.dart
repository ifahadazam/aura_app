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
import 'package:life_goal/features/goals/presentation/bloc/get_streak_goal_bloc/get_streak_goal_bloc.dart';
import 'package:life_goal/features/goals/presentation/pages/daily_reminder_page.dart';

String colorToHex(Color color, {bool includeAlpha = true}) {
  final a = (color.a * 255).round().toRadixString(16).padLeft(2, '0');
  final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
  final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
  final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');

  return '#${includeAlpha ? a : ''}$r$g$b'.toUpperCase();
}

final List<Color> selectableColors = [
  Color(0xFFF67172), // Red-ish
  Color(0xFFFB933C), // Amber
  Color(0xffFBBF23), // Yellow
  Color(0xFFFACC16), // Lime Green
  Color(0xFFA3E636), // Green
  Color(0xff4ADE80), // Teal
  Color(0xFF34D399), // Cyan
  Color(0xFF60A5FA), // Light Blue
  Color(0xFF818CF8), // Indigo
  Color(0xFFA78BFA), // Light Purple
  Color(0xFFE879F9), // Pink-Purple
  Color(0xFFF472B6), // Rose
  Colors.red[200]!, // Light Red
  Colors.deepOrangeAccent,
  Color(0xFF60A5FA), // Light Blue
  Color(0xFF818CF8), // Indigo
  Color.fromARGB(255, 148, 156, 228), // Light Purple
  Color(0xFFF771B6), // Pink-Purple
  Color(0xFF61A5FA),
  Color(0xFF94A3B8), // Slate Blue-Gray
  Color(0xFF9CA3AF), // Gray
];

const colorRow = [
  Color(0xFFF67172), // Red-ish
  Color(0xFFFB933C), // Amber
  Color(0xffFBBF23), // Yellow
  Color(0xFFFACC16), // Lime Green
  Color(0xFFA3E636), // Green
  Color(0xff4ADE80), // Teal
  Color(0xFF34D399), // Cyan
  Color(0xFF61A5FA),
  // Color(0xFF94A3B8),
];

class CreateHabit extends StatefulWidget {
  const CreateHabit({super.key});

  @override
  State<CreateHabit> createState() => _CreateHabitState();
}

class _CreateHabitState extends State<CreateHabit> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode notesFocusNode = FocusNode();
  final ValueNotifier habitType = ValueNotifier<String>('Positive');
  final ValueNotifier showMoreOptions = ValueNotifier<bool>(false);
  final ValueNotifier isValueCustom = ValueNotifier<bool>(false);
  final formKey = GlobalKey<FormState>();
  final ValueNotifier selectedColor = ValueNotifier<Color>(Colors.yellow);

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    notesController.dispose();
    titleFocusNode.dispose();
    notesFocusNode.dispose();
    habitType.dispose();
    showMoreOptions.dispose();
    isValueCustom.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.creamyWhiteColor,
      appBar: InternalPageAppBar(
        title: 'New Habit',
        themeColor: AppColors.themeBlack,
      ),
      body: InkWell(
        splashColor: AppColors.transparentColor,
        onTap: () {
          titleFocusNode.unfocus();
          notesFocusNode.unfocus();
        },
        child: Padding(
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
                    themeColor: AppColors.lightBlackColor,

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
                    themeColor: AppColors.lightBlackColor,
                    // maxLines: 2,
                    textController: notesController,
                    focusNode: notesFocusNode,
                    hintText: 'Add additional notes here..',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),

                  AppConstants.defaultDoubleSpace,
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
                                  choosenColor == colorRow[index];
                              return GestureDetector(
                                onTap: () {
                                  selectedColor.value = colorRow[index];
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isColorSelected
                                          ? AppColors.lightBlackColor
                                          : AppColors.greyColor,
                                    ),
                                    color: colorRow[index],
                                    borderRadius: BorderRadius.circular(6),
                                  ),

                                  child: isColorSelected
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
                          ),
                        );
                      }),
                    ),
                  ),
                  AppConstants.defaultDoubleSpace,
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: AppColors.creamyWhiteColor,
                        showDragHandle: true,

                        context: context,
                        builder: (context) {
                          return SizedBox(
                            width: double.maxFinite,
                            child: Padding(
                              padding: EdgeInsets.all(
                                AppConstants.kMediumPadding,
                              ),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,

                                children: List.generate(
                                  selectableColors.length,
                                  (index) {
                                    return ValueListenableBuilder(
                                      valueListenable: selectedColor,
                                      builder: (context, choosenColor, child) {
                                        final bool isColorSelected =
                                            choosenColor ==
                                            selectableColors[index];
                                        return GestureDetector(
                                          onTap: () {
                                            selectedColor.value =
                                                selectableColors[index];
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: isColorSelected
                                                    ? AppColors.lightBlackColor
                                                    : AppColors.greyColor,
                                              ),
                                              color: selectableColors[index],
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),

                                            child: isColorSelected
                                                ? Center(
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 12,
                                                      color:
                                                          AppColors.themeBlack,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ' More Colors ',
                          style:
                              TypographyTheme.simpleSubTitleStyle(
                                fontSize: 13,
                              ).copyWith(
                                color: AppColors.lightBlackColor.withAlpha(220),
                              ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: AppColors.themeBlack.withAlpha(220),
                          size: 20,
                        ),
                      ],
                    ),
                  ),

                  AppConstants.defaultDoubleSpace,
                  Text(
                    ' Categories',
                    style: TypographyTheme.simpleSubTitleStyle(fontSize: 12),
                  ),

                  AppConstants.defaultSpace,
                  ValueListenableBuilder(
                    valueListenable: habitType,
                    builder: (context, habitCategory, child) {
                      return Row(
                        spacing: 6,
                        children: [
                          HabitCategory(
                            onTap: () {
                              habitType.value = 'Positive';
                            },
                            habitType: habitCategory == 'Positive',
                            title: 'Positive',
                          ),
                          HabitCategory(
                            onTap: () {
                              habitType.value = 'Negative';
                            },
                            habitType: habitCategory == 'Negative',
                            title: 'Negative',
                          ),
                        ],
                      );
                    },
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.themeBlack.withAlpha(220),
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
                                                  return StreakGoal();
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppConstants.kSmallPadding,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: AppConstants
                                                    .widetHalfBorderRadius,
                                                color: AppColors.themeWhite,
                                                border: Border.all(
                                                  color:
                                                      AppColors.lightGreyColor,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  BlocBuilder<
                                                    GetStreakGoalBloc,
                                                    GetStreakGoalState
                                                  >(
                                                    builder: (context, state) {
                                                      final int streakGoal =
                                                          state.streakGoal;
                                                      return Text(
                                                        streakGoal == 0
                                                            ? ' None'
                                                            : '${streakGoal.toString()} Days',
                                                        style:
                                                            TypographyTheme.simpleTitleStyle(
                                                              fontSize: 12,
                                                            ),
                                                      );
                                                    },
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
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    AppConstants.kSmallPadding,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: AppConstants
                                                    .widetHalfBorderRadius,
                                                color: AppColors.themeWhite,
                                                border: Border.all(
                                                  color:
                                                      AppColors.lightGreyColor,
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
                                                          .habitReminderBox,
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
                                                                  fontSize: 12,
                                                                ),
                                                          );
                                                        },
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (isOptionsShown) AppConstants.defaultDoubleSpace,
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
                                      DefaultTabController(
                                        length: 2,
                                        child: Container(
                                          height: 35,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            borderRadius: AppConstants
                                                .widetHalfBorderRadius,
                                            color: AppColors.themeWhite,
                                            border: Border.all(
                                              color: AppColors.lightGreyColor,
                                            ),
                                          ),
                                          child: TabBar(
                                            onTap: (val) {
                                              if (val == 0) {
                                                isValueCustom.value = false;
                                              } else {
                                                isValueCustom.value = true;
                                              }
                                            },
                                            labelColor: AppColors.themeWhite,
                                            unselectedLabelColor:
                                                AppColors.lightBlackColor,
                                            labelStyle:
                                                TypographyTheme.simpleTitleStyle(
                                                  fontSize: 13,
                                                ),
                                            dividerColor: Colors.transparent,
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
                                      ),
                                      AppConstants.defaultDoubleSpace,
                                      if (isValueTypwCustom)
                                        ValueListenableBuilder(
                                          valueListenable: Hive.box(
                                            HiveConstants.unitValuesBox,
                                          ).listenable(),
                                          builder: (context, valueTypeBox, child) {
                                            int valueDigit =
                                                valueTypeBox.get(
                                                  HiveConstants.valueType,
                                                ) ??
                                                1;
                                            return SizedBox(
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
                                                                  style:
                                                                      TypographyTheme.simpleTitleStyle(
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  ' / Day',
                                                                  style:
                                                                      TypographyTheme.simpleSubTitleStyle(
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
                                                                            .unitValuesBox,
                                                                      ).put(
                                                                        HiveConstants
                                                                            .valueType,
                                                                        newVal,
                                                                      );
                                                                    },
                                                                    child: SizedBox(
                                                                      child: Center(
                                                                        child: Icon(
                                                                          CupertinoIcons
                                                                              .minus,
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
                                                                            .unitValuesBox,
                                                                      ).put(
                                                                        HiveConstants
                                                                            .valueType,
                                                                        newVal,
                                                                      );
                                                                    },
                                                                    child: SizedBox(
                                                                      child: Center(
                                                                        child: Icon(
                                                                          CupertinoIcons
                                                                              .add,
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
                                                                  return AddHabitCustomValue();
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
                                            );
                                          },
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
              ),
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
              final int valueCount =
                  await Hive.box(
                    HiveConstants.unitValuesBox,
                  ).get(HiveConstants.valueType) ??
                  0;
              final List<int> reminderDaysList =
                  await Hive.box(
                    HiveConstants.habitReminderBox,
                  ).get(HiveConstants.reminderDays) ??
                  [];
              final reminderTime =
                  await Hive.box(
                    HiveConstants.habitReminderBox,
                  ).get(HiveConstants.reminderTime) ??
                  '';
              final taskService = TaskService();
              if (formKey.currentState!.validate() && context.mounted) {
                final title = titleController.text.trim();
                final subTitle = notesController.text.trim();
                final Color habitColor = selectedColor.value;

                final String selectedColorHex = colorToHex(habitColor);

                final streakDays = context
                    .read<GetStreakGoalBloc>()
                    .state
                    .streakGoal;
                // final isHabitValueCustom = isValueCustom.value ? 1 : 0;
                final newHabit = HabitModel(
                  title: title,
                  description: subTitle,
                  habitValue: 0,
                  valueCount: isValueCustom.value ? valueCount : 0,
                  streakGoal: streakDays,
                  isDone: false,
                  reminderDays: reminderDaysList,
                  reminderTime: reminderTime,
                  habitColor: selectedColorHex,
                  habitKey: DateTime.now().toString(),

                  habitType: habitType.value,
                );
                await taskService.addNewHabit(newHabit);
                if (context.mounted) {
                  context.pop();
                }
              }
            },
            title: 'Save',
            buttonColor: AppColors.themeBlack,
          ),
        ),
      ),
    );
  }
}

class StreakGoal extends StatefulWidget {
  const StreakGoal({super.key});

  @override
  State<StreakGoal> createState() => _StreakGoalState();
}

class _StreakGoalState extends State<StreakGoal> {
  final TextEditingController controller = TextEditingController();

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
            context.read<GetStreakGoalBloc>().add(
              GetStreakGoalEvent(streakGoal: int.parse(controller.text.trim())),
            );
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

class AddHabitCustomValue extends StatefulWidget {
  const AddHabitCustomValue({super.key});

  @override
  State<AddHabitCustomValue> createState() => _AddHabitCustomValueState();
}

class _AddHabitCustomValueState extends State<AddHabitCustomValue> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
              HiveConstants.unitValuesBox,
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

class HabitCategory extends StatelessWidget {
  const HabitCategory({
    super.key,
    required this.habitType,
    required this.title,
    required this.onTap,
  });
  final bool habitType;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: AppConstants.kLargePadding),
        decoration: BoxDecoration(
          color: habitType
              ? AppColors.themeBlack
              : AppColors.xtraLightGreyColor,
          borderRadius: AppConstants.widetHalfBorderRadius,
        ),
        child: Center(
          child: Text(
            title,
            style: TypographyTheme.simpleSubTitleStyle(fontSize: 13).copyWith(
              color: habitType ? AppColors.themeWhite : AppColors.themeBlack,
            ),
          ),
        ),
      ),
    );
  }
}
