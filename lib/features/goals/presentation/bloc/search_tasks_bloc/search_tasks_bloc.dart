import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_goal/features/goals/data/models/tasks_model.dart';

part 'search_tasks_event.dart';
part 'search_tasks_state.dart';

class SearchTasksBloc extends Bloc<SearchTasksEvent, SearchTasksState> {
  List<TasksModel> searchedList = [];
  SearchTasksBloc() : super(SearchTasksState(searchedTasks: [])) {
    on<SearchAllTasksEvent>(_searchAllTasksEvent);
    on<ResetSearchedTasksEvent>(_resetSearchedTasksEvent);
    on<FilterTasksByPriorityEvent>(_filterTasksByPriorityEvent);
  }

  void _searchAllTasksEvent(SearchAllTasksEvent event, emit) {
    final List<TasksModel> allTasks = Hive.box<TasksModel>(
      'tasks',
    ).values.toList();
    searchedList = allTasks.where((eachTask) {
      return eachTask.title.toLowerCase().contains(
            event.queyText.toLowerCase(),
          ) ||
          eachTask.notes.toLowerCase().contains(event.queyText.toLowerCase()) ||
          eachTask.taskDate.toLowerCase().contains(
            event.queyText.toLowerCase(),
          ) ||
          eachTask.taskTime.toLowerCase().contains(
            event.queyText.toLowerCase(),
          );
    }).toList();

    emit(SearchTasksState(searchedTasks: searchedList));
  }

  void _resetSearchedTasksEvent(ResetSearchedTasksEvent event, emit) {
    emit(SearchTasksState(searchedTasks: []));
  }

  void _filterTasksByPriorityEvent(FilterTasksByPriorityEvent event, emit) {
    final List<TasksModel> allTasks = Hive.box<TasksModel>(
      'tasks',
    ).values.toList();
    searchedList = allTasks.where((eachTask) {
      if (event.filterTag == 'High') {
        return eachTask.taskPriority.toLowerCase().contains('high');
      } else if (event.filterTag == 'Pending') {
        return eachTask.isTaskDone == false;
      } else if (event.filterTag == 'Completed') {
        return eachTask.isTaskDone;
      } else {
        return eachTask.taskPriority.toLowerCase().contains('low');
      }
    }).toList();

    emit(SearchTasksState(searchedTasks: searchedList));
  }
}
