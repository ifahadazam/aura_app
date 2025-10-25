part of 'get_daily_reminder_bloc.dart';

class GetDailyReminderState extends Equatable {
  const GetDailyReminderState({
    required this.reminderDays,
    required this.reminderTime,
  });
  final List<int> reminderDays;
  final String reminderTime;

  @override
  List<Object> get props => [reminderTime, reminderDays];
}
