import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_selected_task_priority_event.dart';
part 'get_selected_task_priority_state.dart';

class GetSelectedTaskPriorityBloc
    extends Bloc<GetSelectedTaskPriorityEvent, GetSelectedTaskPriorityState> {
  GetSelectedTaskPriorityBloc()
    : super(GetSelectedTaskPriorityState(taskPriority: '')) {
    on<GetSelectedTaskPriorityEvent>(_getSelectedTaskPriorityEvent);
  }

  void _getSelectedTaskPriorityEvent(GetSelectedTaskPriorityEvent event, emit) {
    emit(GetSelectedTaskPriorityState(taskPriority: event.taskPriority));
  }
}
