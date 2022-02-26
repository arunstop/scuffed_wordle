part of 'package:scuffed_wordle/bloc/board/board_bloc.dart';

abstract class BoardEvent extends Equatable {
  const BoardEvent();

  @override
  List<Object> get props => [];
}

class BoardInitialize extends BoardEvent {
  // final List<List<BoardLetter>> guessWordList;

  // BoardInitialize({required this.guessWordList});
  // final int length;
  // final int lives;
  // final String answer;

  // const BoardInitialize({
  //   required this.length,
  //   required this.lives,
  //   required this.answer,
  // });

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

class BoardAddGuess extends BoardEvent {
  final String guess;
  final int length;
  BoardAddGuess({required this.guess,required this.length});
}

class BoardSubmitGuess extends BoardEvent {
  final Settings settings;
  final List<String> wordList;
  final String answer;

  BoardSubmitGuess({required this.settings, required this.wordList, required this.answer});
}

class BoardRestart extends BoardEvent {
  // final int length;
  // final int lives;

  // const BoardRestart({
  //   required this.length,
  //   required this.lives,
  // });
}

class BoardTest extends BoardEvent {}
