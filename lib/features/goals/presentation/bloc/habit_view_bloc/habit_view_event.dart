part of 'habit_view_bloc.dart';

class HabitViewEvent extends Equatable {
  const HabitViewEvent({required this.viewTag});
  final String viewTag;

  @override
  List<Object> get props => [viewTag];
}
