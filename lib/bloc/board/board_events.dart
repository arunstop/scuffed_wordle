part of 'package:scuffed_wordle/bloc/board/board_bloc.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

class BoardInitialize extends BoardEvent {
  // final List<List<BoardLetter>> guessWordList;

  // BoardInitialize({required this.guessWordList});
  final int length;
  final int lives;

  BoardInitialize({
    required this.length,
    required this.lives,
  });

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

class BoardSubmitGuess extends BoardEvent {}

class BoardRestart extends BoardEvent {}

class BoardTest extends BoardEvent {}
