part of 'bottom_bar_bloc.dart';

class BottomBarState extends Equatable {
  final int index;
  const BottomBarState({this.index = 0});

  BottomBarState copyWith({int? index}) {
    return BottomBarState(
      index: index ?? this.index,
    );
  }

  @override
  List<Object> get props => [index];
}
