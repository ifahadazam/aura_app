part of 'select_reminder_time_bloc.dart';

class SelectReminderTimeEvent extends Equatable {
  const SelectReminderTimeEvent({required this.selectedDay, this.timeOfDay});
  final List<int> selectedDay;
  final TimeOfDay? timeOfDay;

  @override
  List<Object?> get props => [selectedDay, timeOfDay];
}
