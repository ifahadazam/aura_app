part of 'show_expanded_task_bloc_bloc.dart';

sealed class ShowExpandedTaskBlocState extends Equatable {
  const ShowExpandedTaskBlocState();
  
  @override
  List<Object> get props => [];
}

final class ShowExpandedTaskBlocInitial extends ShowExpandedTaskBlocState {}
