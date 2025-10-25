part of 'show_search_task_bar_bloc.dart';

class ShowSearchTaskBarEvent extends Equatable {
  const ShowSearchTaskBarEvent({required this.isSearchBarShown});
  final bool isSearchBarShown;

  @override
  List<Object> get props => [isSearchBarShown];
}
