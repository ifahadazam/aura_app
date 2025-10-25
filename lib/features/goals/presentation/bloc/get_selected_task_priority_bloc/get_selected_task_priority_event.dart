part of 'get_selected_task_priority_bloc.dart';

class GetSelectedTaskPriorityEvent extends Equatable {
  const GetSelectedTaskPriorityEvent({required this.taskPriority});
  final String taskPriority;

  @override
  List<Object> get props => [taskPriority];
}
