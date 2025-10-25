import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'habit_view_event.dart';
part 'habit_view_state.dart';

class HabitViewBloc extends Bloc<HabitViewEvent, HabitViewState> {
  HabitViewBloc() : super(HabitViewState(viewTag: 'weekly')) {
    on<HabitViewEvent>(_habitViewEvent);
  }

  void _habitViewEvent(HabitViewEvent event, emit) {
    emit(HabitViewState(viewTag: event.viewTag));
  }
}
