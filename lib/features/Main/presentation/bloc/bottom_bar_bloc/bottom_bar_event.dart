part of 'bottom_bar_bloc.dart';

abstract class BottomBarEvent extends Equatable {
  const BottomBarEvent();

  @override
  List<Object> get props => [];
}

class GetPageIndexEvent extends BottomBarEvent {
  final int index;
  const GetPageIndexEvent({required this.index});

  @override
  List<Object> get props => [index];
}
