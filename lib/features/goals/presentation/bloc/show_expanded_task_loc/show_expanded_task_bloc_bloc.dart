import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'show_expanded_task_bloc_event.dart';
part 'show_expanded_task_bloc_state.dart';

class ShowExpandedTaskBlocBloc extends Bloc<ShowExpandedTaskBlocEvent, ShowExpandedTaskBlocState> {
  ShowExpandedTaskBlocBloc() : super(ShowExpandedTaskBlocInitial()) {
    on<ShowExpandedTaskBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
