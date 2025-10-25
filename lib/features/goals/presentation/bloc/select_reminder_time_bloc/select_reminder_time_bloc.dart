import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'select_reminder_time_event.dart';
part 'select_reminder_time_state.dart';

class SelectReminderTimeBloc
    extends Bloc<SelectReminderTimeEvent, SelectReminderTimeState> {
  SelectReminderTimeBloc() : super(SelectReminderTimeState(selectedDay: [])) {
    on<SelectReminderTimeEvent>(_selectReminderTimeEvent);
  }

  void _selectReminderTimeEvent(SelectReminderTimeEvent event, emit) {
    emit(
      SelectReminderTimeState(
        selectedDay: event.selectedDay,
        timeOfDay: event.timeOfDay,
      ),
    );
  }
}
