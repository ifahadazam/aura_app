import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/extensions/sized_box.dart';
import 'package:life_goal/core/shared/buttons/icon_tap_button.dart';
import 'package:life_goal/core/shared/custom_text_field.dart';
import 'package:life_goal/core/shared/internal_page_app_bar.dart';
import 'package:life_goal/features/goals/data/models/tasks_model.dart';
import 'package:life_goal/features/goals/data/services/task_service.dart';
import 'package:life_goal/features/goals/presentation/bloc/get_selected_task_priority_bloc/get_selected_task_priority_bloc.dart';
import 'package:life_goal/features/goals/presentation/bloc/search_tasks_bloc/search_tasks_bloc.dart';
import 'package:life_goal/features/goals/presentation/bloc/show_search_task_bar_bloc/show_search_task_bar_bloc.dart';
import 'package:life_goal/features/goals/presentation/pages/create_task.dart';
import 'package:life_goal/features/goals/presentation/pages/edit_task.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamyWhiteColor,
      appBar: InternalPageAppBar(
        title: 'Tasks',
        themeColor: AppColors.themeBlack,
        actions: [
          IconTapButton(
            onTap: () {
              context.read<ShowSearchTaskBarBloc>().add(
                ShowSearchTaskBarEvent(isSearchBarShown: true),
              );
            },
            iconDta: Icons.search,
            iconColor: AppColors.themeBlack,
            iconSize: 24,
          ),
          AppConstants.singleWidth,
        ],
      ),
      body: Padding(
        padding: AppConstants.pagesInternalPadding,
        child: Column(
          children: [
            BlocBuilder<ShowSearchTaskBarBloc, ShowSearchTaskBarState>(
              builder: (context, state) {
                final bool isSearchBarShown = state.isSearchBarShown;
                return !isSearchBarShown
                    ? BlocBuilder<
                        GetSelectedTaskPriorityBloc,
                        GetSelectedTaskPriorityState
                      >(
                        builder: (context, state) {
                          final taskPriority = state.taskPriority;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 6,
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: [
                                FilterListButton(
                                  onTap: () {
                                    context
                                        .read<GetSelectedTaskPriorityBloc>()
                                        .add(
                                          GetSelectedTaskPriorityEvent(
                                            taskPriority: '',
                                          ),
                                        );
                                    context.read<SearchTasksBloc>().add(
                                      ResetSearchedTasksEvent(),
                                    );
                                  },
                                  isSelected: taskPriority == '',
                                  title: 'All',
                                ),
                                FilterListButton(
                                  onTap: () {
                                    context
                                        .read<GetSelectedTaskPriorityBloc>()
                                        .add(
                                          GetSelectedTaskPriorityEvent(
                                            taskPriority: 'High',
                                          ),
                                        );
                                    context.read<SearchTasksBloc>().add(
                                      FilterTasksByPriorityEvent(
                                        filterTag: 'High',
                                      ),
                                    );
                                  },
                                  isSelected: taskPriority == 'High',
                                  title: 'High',
                                ),
                                FilterListButton(
                                  onTap: () {
                                    context
                                        .read<GetSelectedTaskPriorityBloc>()
                                        .add(
                                          GetSelectedTaskPriorityEvent(
                                            taskPriority: 'Low',
                                          ),
                                        );
                                    context.read<SearchTasksBloc>().add(
                                      FilterTasksByPriorityEvent(
                                        filterTag: 'Low',
                                      ),
                                    );
                                  },
                                  isSelected: taskPriority == 'Low',
                                  title: 'Low',
                                ),
                                FilterListButton(
                                  isSelected: taskPriority == 'Pending',
                                  title: 'Pending',
                                  onTap: () {
                                    context
                                        .read<GetSelectedTaskPriorityBloc>()
                                        .add(
                                          GetSelectedTaskPriorityEvent(
                                            taskPriority: 'Pending',
                                          ),
                                        );
                                    context.read<SearchTasksBloc>().add(
                                      FilterTasksByPriorityEvent(
                                        filterTag: 'Pending',
                                      ),
                                    );
                                  },
                                ),
                                FilterListButton(
                                  isSelected: taskPriority == 'Completed',
                                  title: 'Completed',
                                  onTap: () {
                                    context
                                        .read<GetSelectedTaskPriorityBloc>()
                                        .add(
                                          GetSelectedTaskPriorityEvent(
                                            taskPriority: 'Completed',
                                          ),
                                        );
                                    context.read<SearchTasksBloc>().add(
                                      FilterTasksByPriorityEvent(
                                        filterTag: 'Completed',
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : SearchTasks();
              },
            ),

            AppConstants.defaultSpace,

            BlocBuilder<SearchTasksBloc, SearchTasksState>(
              builder: (context, state) {
                final searchedTasks = state.searchedTasks;
                return ValueListenableBuilder(
                  valueListenable: Hive.box<TasksModel>('tasks').listenable(),
                  builder: (context, taskBox, child) {
                    final allTasks = searchedTasks.isEmpty
                        ? taskBox.values.toList()
                        : searchedTasks;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: allTasks.length,
                        itemBuilder: (context, index) {
                          final singleTask = allTasks[index];
                          final title = allTasks[index].title;
                          final deadline = allTasks[index].taskDate;
                          final isDone = allTasks[index].isTaskDone;

                          final date = DateFormat(
                            'd-MMM-yyyy',
                            'en_US',
                          ).parseStrict(deadline);

                          String monthFull = DateFormat(
                            'MMMM',
                          ).format(date); // July

                          // final DateTime formattedDate = DateTime.parse(deadline);
                          final taskTime =
                              '${date.day} $monthFull - ${allTasks[index].taskTime}';

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.kSmallPadding / 2,
                            ),
                            child: BasicSlidableTile(
                              onTapAction: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog.adaptive(
                                      backgroundColor: AppColors.lightGreyColor,
                                      title: Text(
                                        'Are you sure?',
                                        style: TypographyTheme.simpleTitleStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style:
                                                TypographyTheme.simpleTitleStyle(
                                                  fontSize: 14,
                                                ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await TaskService().deleteTask(
                                              singleTask.taskKey,
                                            );
                                            await TaskService()
                                                .saveCompletedTasksCount();
                                            await TaskService()
                                                .savePendingTasksCount();
                                            if (context.mounted) {
                                              context.pop();
                                            }
                                          },
                                          child: Text(
                                            'Delete',
                                            style:
                                                TypographyTheme.simpleTitleStyle(
                                                  fontSize: 14,
                                                ).copyWith(
                                                  color: AppColors.redColor,
                                                ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              actionWidth: 50,
                              child: EachTask(
                                isPriorityHigh:
                                    singleTask.taskPriority == 'High'
                                    ? true
                                    : false,
                                onTapDone: () async {
                                  final currentTask = Hive.box<TasksModel>(
                                    'tasks',
                                  ).get(singleTask.taskKey);
                                  // log('CT: ${currentTask!.isTaskDone}');
                                  if (currentTask != null) {
                                    final TasksModel updatedTask = currentTask
                                        .copyWith(isTaskDone: true);
                                    await Hive.box<TasksModel>(
                                      'tasks',
                                    ).put(singleTask.taskKey, updatedTask);
                                    TaskService().saveCompletedTasksCount();
                                  }
                                },
                                title: title,
                                deadline: taskTime,
                                isDone: isDone,
                                onTapTrailing: () async {
                                  if (isDone) {
                                    final currentTask = Hive.box<TasksModel>(
                                      'tasks',
                                    ).get(singleTask.taskKey);
                                    // log('CT: ${currentTask!.isTaskDone}');
                                    if (currentTask != null) {
                                      final TasksModel updatedTask = currentTask
                                          .copyWith(isTaskDone: false);
                                      await Hive.box<TasksModel>(
                                        'tasks',
                                      ).put(singleTask.taskKey, updatedTask);
                                    }
                                    await TaskService()
                                        .saveCompletedTasksCount();
                                  } else {
                                    showModalBottomSheet(
                                      useSafeArea: true,
                                      showDragHandle: true,
                                      elevation: 30,
                                      isScrollControlled: true,
                                      backgroundColor:
                                          AppColors.creamyWhiteColor,
                                      context: context,
                                      builder: (context) {
                                        return EditTask(task: allTasks[index]);
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.themeBlack,
        onPressed: () {
          showModalBottomSheet(
            useSafeArea: true,
            showDragHandle: true,
            elevation: 30,
            isScrollControlled: true,
            backgroundColor: AppColors.creamyWhiteColor,
            context: context,
            builder: (context) {
              return CreateTask();
            },
          );
        },
        child: Icon(Icons.add, color: AppColors.themeWhite, size: 24),
      ),
    );
  }
}

class SearchTasks extends StatefulWidget {
  const SearchTasks({super.key});

  @override
  State<SearchTasks> createState() => _SearchTasksState();
}

class _SearchTasksState extends State<SearchTasks> {
  final TextEditingController searchTasksController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchTasksController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.maxFinite,
      child: Row(
        children: [
          Expanded(
            child: TextInputField(
              onChanged: (text) {
                if (text != '' && text != null) {
                  context.read<SearchTasksBloc>().add(
                    SearchAllTasksEvent(queyText: text),
                  );
                } else {
                  context.read<SearchTasksBloc>().add(
                    ResetSearchedTasksEvent(),
                  );
                }
                return null;
              },
              themeColor: AppColors.lightBlackColor,
              textController: searchTasksController,
              hintText: 'Search Tasks',
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
          ),
          AppConstants.singleWidth,
          InkWell(
            onTap: () {
              context.read<ShowSearchTaskBarBloc>().add(
                ShowSearchTaskBarEvent(isSearchBarShown: false),
              );
              context.read<SearchTasksBloc>().add(ResetSearchedTasksEvent());
            },
            child: Icon(Icons.close, color: AppColors.redColor, size: 26),
          ),
          AppConstants.singleWidth,
        ],
      ),
    );
  }
}

class EachTask extends StatelessWidget {
  const EachTask({
    super.key,
    required this.title,
    required this.deadline,
    required this.isDone,
    required this.onTapTrailing,
    required this.onTapDone,
    required this.isPriorityHigh,
  });
  final String title;
  final String deadline;
  final bool isDone;
  final VoidCallback onTapTrailing;
  final VoidCallback onTapDone;
  final bool isPriorityHigh;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.maxFinite,
      padding: AppConstants.widgetInternalPadding,
      decoration: BoxDecoration(
        color: AppColors.themeWhite,
        borderRadius: AppConstants.widgetBorderRadius,
        border: Border.all(
          color: isPriorityHigh
              ? AppColors.lightRedColor
              : AppColors.lightGreyColor,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onTapDone,
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: isDone
                    ? AppColors.lightBlackColor
                    : AppColors.xtraLightGreyColor,
                borderRadius: AppConstants.widgetMediumBorderRadius,
              ),
              child: Center(
                child: Icon(
                  Icons.done,
                  size: 25,
                  color: isDone ? AppColors.themeWhite : AppColors.greyColor,
                ),
              ),
            ),
          ),
          AppConstants.singleWidth,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,

                  style: TypographyTheme.simpleTitleStyle(fontSize: 14)
                      .copyWith(
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isDone
                            ? AppColors.greyColor
                            : AppColors.themeBlack,
                      ),
                ),
                Text(
                  deadline,
                  style: TypographyTheme.simpleSubTitleStyle(fontSize: 12)
                      .copyWith(
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: isDone
                            ? AppColors.greyColor
                            : AppColors.themeBlack,
                      ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onTapTrailing,
            child: Icon(
              isDone ? Icons.undo_rounded : Icons.edit,
              color: AppColors.themeBlack,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class BasicSlidableTile extends StatefulWidget {
  const BasicSlidableTile({
    super.key,
    required this.child,
    required this.onTapAction,
    this.height = 65,
    required this.actionWidth,
  });

  final Widget child;
  final VoidCallback onTapAction;
  final double height;
  final double actionWidth;

  @override
  State<BasicSlidableTile> createState() => _BasicSlidableTileState();
}

class _BasicSlidableTileState extends State<BasicSlidableTile> {
  double offsetX = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // 1️⃣ Hidden Action behind the tile
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: widget.onTapAction,
                child: SizedBox(
                  width: widget.actionWidth,
                  height: 65,
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: AppConstants.widgetBorderRadius,
                          color: AppColors.lightRedColor.withAlpha(100),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            color: AppColors.redColor,
                            size: 25,
                          ),
                        ),
                      ),
                      5.width,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2️⃣ Foreground draggable tile
          Transform.translate(
            offset: Offset(offsetX, 0),
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  offsetX += details.delta.dx;
                  offsetX = offsetX.clamp(0, widget.actionWidth);
                });
              },
              onHorizontalDragEnd: (_) {
                // Snap logic: open if dragged more than half
                if (offsetX > widget.actionWidth / 2) {
                  setState(() => offsetX = widget.actionWidth);
                } else {
                  setState(() => offsetX = 0);
                }
              },
              onTap: () {
                // Close on tap if already open
                if (offsetX > 0) {
                  setState(() => offsetX = 0);
                }
              },
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterListButton extends StatelessWidget {
  const FilterListButton({
    super.key,
    required this.isSelected,
    required this.title,
    required this.onTap,
  });
  final bool isSelected;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: AppConstants.kLargePadding),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.themeBlack
              : AppColors.xtraLightGreyColor,
          borderRadius: AppConstants.widetHalfBorderRadius,
        ),
        child: Center(
          child: Text(
            title,
            style: TypographyTheme.simpleSubTitleStyle(fontSize: 13).copyWith(
              color: isSelected ? AppColors.themeWhite : AppColors.themeBlack,
            ),
          ),
        ),
      ),
    );
  }
}
