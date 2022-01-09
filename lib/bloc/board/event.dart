part of 'package:scuffed_wordle/bloc/board/bloc.dart';

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

class BoardRemove extends BoardEvent {
  final String letter;

  const BoardRemove({required this.letter});

  @override
  List<Object> get props => [letter];
}
