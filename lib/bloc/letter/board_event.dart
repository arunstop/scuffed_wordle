part of 'package:scuffed_wordle/bloc/letter/board_bloc.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

class BoardAdd extends BoardEvent {
  final String letter;

  const BoardAdd({required this.letter});

  @override
  List<Object> get props => [letter];
}

class Remove extends BoardEvent {
  @override
  List<Object> get props => [];
}
