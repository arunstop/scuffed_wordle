part of 'package:scuffed_wordle/bloc/board/bloc_board.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

class BoardAddLetter extends BoardEvent {
  final String letter;

  const BoardAddLetter({required this.letter});

  @override
  List<Object> get props => [letter];
}

class BoardRemoveLetter extends BoardEvent {}
class BoardSubmitWord extends BoardEvent {}
class BoardRestart extends BoardEvent {}