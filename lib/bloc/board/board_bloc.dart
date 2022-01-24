import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/models/model_board_letter.dart';
import 'package:scuffed_wordle/ui.dart';
part 'package:scuffed_wordle/bloc/board/board_events.dart';
part 'package:scuffed_wordle/bloc/board/board_states.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  static final BoardLetter _boardLetter = BoardLetter('', BoardColors.base);
  static final _initWordList = [
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
    ],
    [
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
      _boardLetter,
    ],
  ];
  // static const _initWord = ['', '', '', '', ''];
  static const List<String> _initWord = [];

  static final BoardInit _boardInit =
      BoardInit(word: _initWord, wordList: _initWordList);

  final DictionaryBloc dictionaryBloc;
  late final StreamSubscription DictionarySub;
  List<String> dictionaryList = [];
  String keyword = "";

  BoardBloc({required this.dictionaryBloc}) : super(_boardInit) {
    // Listen to dictionaryBloc
    DictionarySub = dictionaryBloc.stream.listen((state) {
      // Set the word list
      dictionaryList = state.list.map((e) => e.toLowerCase()).toList();
      dictionaryList.sortBy((element) => element);
      // Set the keyword
      keyword = state.keyword;

      // print(dictionaryList.toSet().map((e) => '"$e"').toList());
    });
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
      } else {
        var strWord = state.word.join().toLowerCase();
        // If the word is not in word list
        if (!dictionaryList.contains(strWord)) {
          Fluttertoast.showToast(
            msg: "${strWord.toUpperCase()} is not in word list",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            webPosition: 'center',
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            webBgColor: "#f44336",
            textColor: Colors.white,
          );
          return;
        }
        // Copy the wordList state value
        var wordList = [...state.wordList];
        // Change the value based on index/attempt
        var attempt = state.attempt;
        // check the greens
        // then the yellows

        var keywordAsList = keyword.toUpperCase().split('');
        // var stateWord = state.word;

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
                keywordAsList[keywordAsList.indexOf(coloredLetter.letter)] =
                    '-';
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
        // strWord = wordList[attempt - 1].map((e) => e.letter).join();
        if (strWord.toLowerCase() == keyword.toLowerCase() ||
            state.attempt > state.attemptLimit) {
          // Not adding attempt if user guessed it right
          var attempt = strWord.toLowerCase() == keyword.toLowerCase()
              ? state.attempt - 1
              : state.attempt;
          emit(BoardSubmitted(
            wordList: state.wordList,
            attempt: attempt,
          ));
          // Show the keyword
          Fluttertoast.showToast(
            msg: keyword.toUpperCase(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            webPosition: 'center',
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            webBgColor: "#4caf50",
            textColor: Colors.white,
          );
          return;
        }
      }
    });

    on<BoardRestart>((event, emit) {
      emit(_boardInit);
    });
    on<BoardTest>((event, emit) {
      emit(state.copywith(attemptLimit: Random().nextInt(51)));
    });
  }
  @override
  Future<void> close() {
    DictionarySub.cancel();
    return super.close();
  }
}
