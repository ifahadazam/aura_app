part of 'habit_view_bloc.dart';

class HabitViewState extends Equatable {
  const HabitViewState({required this.viewTag});
  final String viewTag;

  @override
  List<Object> get props => [viewTag];
}
