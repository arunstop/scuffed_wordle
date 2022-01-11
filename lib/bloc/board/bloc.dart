import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  static const _initWord = ['', '', '', '', ''];

  static final BoardInit _boardInit =
      BoardInit(word: _initWord, wordList: _initWordList);
  BoardBloc() : super(_boardInit) {
    // Add letter whenever alphabet key is pressed
    on<BoardAddLetter>((event, emit) {
      // Count typed letters by eliminating the empty values from state.word
      var typedLetters = [...state.word, event.letter];
      typedLetters.removeWhere((element) => element == '');

      if (typedLetters.length > 5) {
        return;
      }
      // Get the typing index
      var wordIndex = typedLetters.length - 1;
      // Change the values based on that count.
      var wordClone = [...state.word];
      wordClone[wordIndex] = event.letter;
      // Apply the changes
      emit(state.copywith(
        word: wordClone,
      ));
    });
    // Remove letter when backspace key is pressed
    on<BoardRemoveLetter>((event, emit) {
      // Proceed if the word is not empty
      if (state.word.isEmpty) {
        return;
      }
      // Count typed letters by eliminating the empty values from state.word
      var typedLetters = [...state.word];
      typedLetters.removeWhere((element) => element == '');
      // Get the typing index
      var wordIndex = typedLetters.length - 1;
      // Change the values based on that count.
      var wordClone = [...state.word];
      wordClone[wordIndex] = '';

      emit(state.copywith(word: wordClone));
    });

    // Submit word when enter key is pressed
    on<BoardSubmitWord>((event, emit) {
      // Count typed letters by eliminating the empty values from state.word
      var typedLetters = [...state.word];
      typedLetters.removeWhere((element) => element == '');
      // Submit word when the count is 5 letter
      if (typedLetters.length == 5) {
        // Copy the wordList state value
        var submittedWord = [...state.wordList];
        // Change the value based on index/attempt
        var attempt = state.attempt;
        submittedWord[attempt - 1] = state.word;
        // Apply the changes
        emit(state.copywith(
          word: _initWord,
          wordList: submittedWord,
          attempt: attempt + 1,
        ));

        // Restart if board is full
        if (state.attempt == state.attemptLimit + 1) {
          // print(state.wordList);
          // emit(_boardInit);
          print('submit');
        }
      } else {
        print('Need more');
      }
    });
  }
}
