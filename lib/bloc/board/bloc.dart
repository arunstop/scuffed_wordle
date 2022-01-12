import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/ui.dart';
part 'package:scuffed_wordle/bloc/board/event.dart';
part 'package:scuffed_wordle/bloc/board/state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  static const _initWordList = [
    ['', '', '', '', '', ''],
    ['', '', '', '', '', ''],
    ['', '', '', '', '', ''],
    ['', '', '', '', '', ''],
    ['', '', '', '', '', ''],
    ['', '', '', '', '', ''],
  ];
  // static const _initWord = ['', '', '', '', ''];
  static const List<String> _initWord = [];

  static final BoardInit _boardInit =
      BoardInit(word: _initWord, wordList: _initWordList);
  BoardBloc() : super(_boardInit) {
    // Add letter whenever an alphabet key is pressed
    on<BoardAddLetter>((event, emit) {
      // Count typed letters
      var typedLetters = [...state.word, event.letter];
      // if typed letters is 5 or more, do nothing
      if (typedLetters.length > 5) {
        return;
      }
      // Apply changes
      emit(state.copywith(
        word: typedLetters,
      ));
    });
    // Remove letter when backspace key is pressed
    on<BoardRemoveLetter>((event, emit) {
      // Count typed letters
      var typedLetters = [...state.word];
      // Proceed if the word is not empty
      if (typedLetters.isEmpty) {
        return;
      }
      // Remove the last letter
      typedLetters.removeLast();
      // Apply changes
      emit(state.copywith(word: typedLetters));
    });

    // Submit word when enter key is pressed
    on<BoardSubmitWord>((event, emit) {
      // Submit word when the count is 5 letter
      if (state.word.length == 5) {
        // Copy the wordList state value
        var submittedWord = [...state.wordList];
        // Change the value based on index/attempt
        var attempt = state.attempt;
        submittedWord[attempt - 1] = state.word;
        // Apply changes
        emit(state.copywith(
          word: _initWord,
          wordList: submittedWord,
          attempt: attempt + 1,
        ));
        var strWord = submittedWord[attempt - 1].join();
        if (strWord.toLowerCase() == UiController.keyWord.toLowerCase()) {
          emit(BoardSubmitted(wordList: state.wordList));
          return;
        }
        // Restart if board is full
        if (state.attempt > state.attemptLimit) {
          // print(state.wordList);
          // emit(_boardInit);
          // print('submit');
        }
      } else {
        print('Need more');
      }
    });
  }
}
