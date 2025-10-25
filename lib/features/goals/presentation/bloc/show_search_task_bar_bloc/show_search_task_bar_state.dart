part of 'show_search_task_bar_bloc.dart';

class ShowSearchTaskBarState extends Equatable {
  const ShowSearchTaskBarState({required this.isSearchBarShown});
  final bool isSearchBarShown;

  @override
  List<Object> get props => [isSearchBarShown];
}
