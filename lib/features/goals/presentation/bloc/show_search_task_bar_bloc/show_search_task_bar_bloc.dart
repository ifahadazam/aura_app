import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'show_search_task_bar_event.dart';
part 'show_search_task_bar_state.dart';

class ShowSearchTaskBarBloc
    extends Bloc<ShowSearchTaskBarEvent, ShowSearchTaskBarState> {
  ShowSearchTaskBarBloc()
    : super(ShowSearchTaskBarState(isSearchBarShown: false)) {
    on<ShowSearchTaskBarEvent>(_showSearchTaskBarEvent);
  }

  void _showSearchTaskBarEvent(ShowSearchTaskBarEvent event, emit) {
    emit(ShowSearchTaskBarState(isSearchBarShown: event.isSearchBarShown));
  }
}
