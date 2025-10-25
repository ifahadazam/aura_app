part of 'get_streak_goal_bloc.dart';

class GetStreakGoalEvent extends Equatable {
  const GetStreakGoalEvent({required this.streakGoal});
  final int streakGoal;

  @override
  List<Object> get props => [streakGoal];
}
