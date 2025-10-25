part of 'select_reminder_time_bloc.dart';

class SelectReminderTimeState extends Equatable {
  const SelectReminderTimeState({required this.selectedDay, this.timeOfDay});
  final List<int> selectedDay;
  final TimeOfDay? timeOfDay;

  @override
  List<Object?> get props => [selectedDay, timeOfDay];
}
