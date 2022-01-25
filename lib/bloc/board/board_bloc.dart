import 'dart:async';
import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_states.dart';
import 'package:scuffed_wordle/models/model_board_letter.dart';
import 'package:scuffed_wordle/ui.dart';
part 'package:scuffed_wordle/bloc/board/board_events.dart';
part 'package:scuffed_wordle/bloc/board/board_states.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  static final BoardLetter _boardLetter = BoardLetter('', BoardColors.base);
  static final _initWordList = [
    for (var i = 1; i <= 6; i++) [for (var i = 1; i <= 5; i++) _boardLetter]
  ];
  // static const _initWord = ['', '', '', '', ''];
  static const List<String> _initWord = [];

  static final BoardInit _boardInit =
      BoardInit(word: _initWord, wordList: _initWordList);

  final DictionaryBloc dictionaryBloc;
  final SettingsBloc settingsBloc;
  late final StreamSubscription dictionaryStream;
  late final StreamSubscription settingsStream;
  List<String> dictionaryList = [];
  SettingsState settingsState = SettingsDefault();
  String keyword = "";

  @override
  Future<void> close() {
    dictionaryStream.cancel();
    dictionaryStream.cancel();
    return super.close();
  }

  BoardBloc({
    required this.dictionaryBloc,
    required this.settingsBloc,
  }) : super(_boardInit) {
    // Listen to dictionaryBloc
    dictionaryStream = dictionaryBloc.stream.listen(_dictionaryBlocListener);
    // Listen to settingsBloc
    settingsStream = settingsBloc.stream.listen(_settingsBlocListener);
    // Add letter whenever an alphabet key is pressed
    on<BoardAddLetter>(_onBoardAddLetter);
    // Remove letter when backspace key is pressed
    on<BoardRemoveLetter>(_onBoardRemoveLetter);
    // Submit word when enter key is pressed
    on<BoardSubmitWord>(_onBoardSubmitWord);
    // Restart game
    on<BoardRestart>(_onBoardRestart);
  }

  void _dictionaryBlocListener(DictionaryState state) {
    // Set the word list
    dictionaryList = state.list
        .map((e) => e.toLowerCase())
        .toList()
        .sortedBy((element) => element);
    // dictionaryList.sortedBy((element) => element);
    // Set the keyword
    keyword = state.keyword;

    // print(dictionaryList.toSet().map((e) => '"$e"').toList());
  }

  void _settingsBlocListener(SettingsState state) => settingsState = state;

  void _onBoardAddLetter(BoardAddLetter event, Emitter<BoardState> emit) {
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
  }

  void _onBoardRemoveLetter(BoardRemoveLetter event, Emitter<BoardState> emit) {
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
  }

  void _showToast({required String title, required String strColor}) {
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      webPosition: 'center',
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      webBgColor: strColor,
      textColor: Colors.white,
    );
  }

  void _onBoardSubmitWord(BoardSubmitWord event, Emitter<BoardState> emit) {
    // Submit word when the count is 5 letter
    if (state.word.length < 5) {
      Fluttertoast.showToast(
        msg: "Not enough letter",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        webPosition: 'center',
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        webBgColor: "#f44336",
        textColor: Colors.white,
      );
    }
    // If user is in the hard mode and not using the green letters they found

    //
    else {
      var strWord = state.word.join().toLowerCase();
      bool err = false;

      if (settingsState.hardMode == true && state.attempt > 1) {
        // Get latest answer
        List<BoardLetter> latestSubmittedWord =
            state.wordList[state.attempt - 2];
        // Process the current answer
        latestSubmittedWord.forEachIndexed((element, idx) {
          if (err == true) return;
          // Green hint should be re-used in the current answer
          if (element.color == BoardColors.pinpoint) {
            // if not show error and call don't proceed
            if (element.letter != state.word[idx]) {
              _showToast(
                title: 'Letter no. ${idx + 1} must be ${element.letter}',
                strColor: "#f44336",
              );
              err = true;
            }
          } 
          // Yellow hint should be included in the current answer
          else if (element.color == BoardColors.okLetter) {
            // if not show error and call don't proceed
            if (!state.word.contains(element.letter)) {
              _showToast(
                title: 'Letter ${element.letter} must be included',
                strColor: "#f44336",
              );
              err = true;
            }
          }
        });
        if (err == true) return;
      }
      // If the word is not in word list
      if (!dictionaryList.contains(strWord)) {
        _showToast(
          title: "${strWord.toUpperCase()} is not in word list",
          strColor: "#f44336",
        );
        return;
      }
      // Copy the wordList state value
      var wordList = [...state.wordList];
      // Change the value based on index/attempt
      var attempt = state.attempt;

      var keywordAsList = keyword.toUpperCase().split('');

      // Process the typed word
      List<BoardLetter> coloredWordList = state.word
          // Check the right-letter-right-position ones
          .mapIndexed((index, letter) {
            // check if it is right-letter-right-position
            if (keywordAsList[index] == letter) {
              // write off the letter of keyword if it is checked
              keywordAsList[index] = '-';
              return BoardLetter(letter, BoardColors.pinpoint);
            }
            return BoardLetter(letter, BoardColors.base);
          })
          .toList()
          // Then check the right-letter-wrong-position ones
          .mapIndexed((index, coloredLetter) {
            // check if the letter is in the keyword
            // and if the letter is not green arleady
            if (keywordAsList.contains(coloredLetter.letter) &&
                coloredLetter.color != BoardColors.pinpoint) {
              // write off the letter of keyword if it is checked
              // by finding the index of targeted keyword letter
              keywordAsList[keywordAsList.indexOf(coloredLetter.letter)] = '-';
              return BoardLetter(coloredLetter.letter, BoardColors.okLetter);
            }
            return coloredLetter;
          })
          .toList();

      // Change wordList value based on attempt
      wordList[attempt - 1] = coloredWordList;

      // Apply changes on the bloc
      emit(state.copywith(
        word: _initWord,
        wordList: wordList,
        attempt: attempt + 1,
      ));

      // If the submitted word is corrent, end the game
      if (strWord.toLowerCase() == keyword.toLowerCase() ||
          state.attempt > state.attemptLimit) {
        // Not adding attempt if user guessed it right
        var attempt = strWord.toLowerCase() == keyword.toLowerCase()
            ? state.attempt - 1
            : state.attempt;
        // Apply changes tot the bloc
        emit(BoardSubmitted(
          wordList: state.wordList,
          attempt: attempt,
        ));
        // Show the keyword
        _showToast(
          title: keyword.toUpperCase(),
          strColor: "#4caf50",
        );
        return;
      }
    }
  }

  void _onBoardRestart(BoardRestart event, Emitter<BoardState> emit) {
    emit(_boardInit);
  }
}
