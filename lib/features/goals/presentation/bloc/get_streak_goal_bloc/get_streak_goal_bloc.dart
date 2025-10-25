import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_streak_goal_event.dart';
part 'get_streak_goal_state.dart';

class GetStreakGoalBloc extends Bloc<GetStreakGoalEvent, GetStreakGoalState> {
  GetStreakGoalBloc() : super(GetStreakGoalState(streakGoal: 0)) {
    on<GetStreakGoalEvent>(_getStreakGoalEvent);
  }

  void _getStreakGoalEvent(GetStreakGoalEvent event, emit) {
    emit(GetStreakGoalState(streakGoal: event.streakGoal));
  }
}
