part of 'search_tasks_bloc.dart';

class SearchTasksState extends Equatable {
  const SearchTasksState({required this.searchedTasks});
  final List<TasksModel> searchedTasks;

  @override
  List<Object> get props => [searchedTasks];
}
