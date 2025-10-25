part of 'search_tasks_bloc.dart';

abstract class SearchTasksEvent extends Equatable {
  const SearchTasksEvent();

  @override
  List<Object> get props => [];
}

class SearchAllTasksEvent extends SearchTasksEvent {
  const SearchAllTasksEvent({required this.queyText});
  final String queyText;

  @override
  List<Object> get props => [queyText];
}

class FilterTasksByPriorityEvent extends SearchTasksEvent {
  const FilterTasksByPriorityEvent({required this.filterTag});
  final String filterTag;

  @override
  List<Object> get props => [filterTag];
}

class ResetSearchedTasksEvent extends SearchTasksEvent {
  const ResetSearchedTasksEvent();

  @override
  List<Object> get props => [];
}
