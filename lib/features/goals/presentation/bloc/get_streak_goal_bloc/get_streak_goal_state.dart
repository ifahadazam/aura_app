part of 'get_streak_goal_bloc.dart';

class GetStreakGoalState extends Equatable {
  const GetStreakGoalState({required this.streakGoal});
  final int streakGoal;

  @override
  List<Object> get props => [streakGoal];
}
