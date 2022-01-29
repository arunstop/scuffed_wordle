part of 'package:scuffed_wordle/bloc/board/board_bloc.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

class BoardInitialize extends BoardEvent {
  // final List<List<BoardLetter>> guessWordList;

  // BoardInitialize({required this.guessWordList});

  // @override
  // List<Object> get props => [guessWordList];
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

class BoardTest extends BoardEvent {}
