part of 'get_selected_task_priority_bloc.dart';

class GetSelectedTaskPriorityState extends Equatable {
  const GetSelectedTaskPriorityState({required this.taskPriority});
  final String taskPriority;

  @override
  List<Object> get props => [taskPriority];
}
