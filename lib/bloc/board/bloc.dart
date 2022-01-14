import 'dart:html';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/models/model__board_letter.dart';
import 'package:scuffed_wordle/ui.dart';
part 'package:scuffed_wordle/bloc/board/event.dart';
part 'package:scuffed_wordle/bloc/board/state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  static final BoardLetter _boardLetter = BoardLetter('', BoardColors.base);
  static final _initWordList = [
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter
    ],
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
      // Apply changes on the bloc
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
      // Apply changes on the bloc
      emit(state.copywith(word: typedLetters));
    });

    // Submit word when enter key is pressed
    on<BoardSubmitWord>((event, emit) {
      // Submit word when the count is 5 letter
      if (state.word.length == 5) {
        // Copy the wordList state value
        var wordList = [...state.wordList];
        // Change the value based on index/attempt
        var attempt = state.attempt;

        Color? getColor(int index, String letter) {
          var keyWord = UiController.keyWord.toUpperCase().split('');
          if (letter == keyWord[index]) {
            return BoardColors.pinpoint;
          } else if (keyWord.contains(letter)) {
            return BoardColors.okLetter;
          }
          return BoardColors.base;
        }

        // Give the submitted word color property
        List<BoardLetter> coloredWord = state.word
            .mapIndexed((index, element) =>
                BoardLetter(element, getColor(index, element)))
            .toList();
        // Change the value based on attempt
        wordList[attempt - 1] = coloredWord;
        // Apply changes on the bloc
        emit(state.copywith(
          word: _initWord,
          wordList: wordList,
          attempt: attempt + 1,
        ));
        // If the submitted word is corrent, end the game
        var strWord = wordList[attempt - 1].map((e) => e.letter).join();
        if (strWord.toLowerCase() == UiController.keyWord.toLowerCase() ||
            state.attempt > state.attemptLimit) {
          emit(BoardSubmitted(
            wordList: state.wordList,
            attempt: state.attempt - 1,
          ));
          return;
        }
      } else {
        // print('Need more');
      }
    });

    on<BoardRestart>((event, emit) {
      emit(_boardInit);
    });
  }
}
