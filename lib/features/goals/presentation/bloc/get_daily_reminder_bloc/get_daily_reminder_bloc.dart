import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_daily_reminder_event.dart';
part 'get_daily_reminder_state.dart';

class GetDailyReminderBloc
    extends Bloc<GetDailyReminderEvent, GetDailyReminderState> {
  GetDailyReminderBloc()
    : super(GetDailyReminderState(reminderDays: [], reminderTime: '')) {
    on<GetDailyReminderEvent>(_getDailyReminderEvent);
  }

  void _getDailyReminderEvent(GetDailyReminderEvent event, emit) {
    emit(
      GetDailyReminderState(
        reminderDays: event.reminderDays,
        reminderTime: event.reminderTime,
      ),
    );
  }
}
