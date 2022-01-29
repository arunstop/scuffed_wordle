import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:scuffed_wordle/data/constants.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:scuffed_wordle/data/models/model_board_letter.dart';
import 'package:scuffed_wordle/data/repositories/board_repository.dart';

class BoardService implements BoardRepo {
  final Future<SharedPreferences> prefs;
  SharedPreferences? localStorage;
  BoardService({
    required this.prefs,
  });

  @override
  Future<List<List<BoardLetter>>> getLocalGuessWordList({
    required String answerWord,
  }) async {
    localStorage = await prefs;

    List rawData = jsonDecode((localStorage!
        .getString(Constants.localStorageKeys.guessWordList)??[])
        .toString());

    List<String> localGuessWordList = rawData.map((e) => e.toString()).toList();
    List<List<BoardLetter>> guessWordList = processGuessWordList(
        guessWordList: localGuessWordList, answerWord: answerWord);
    return guessWordList;
  }

  @override
  void setLocalGuessWordList({required List<String> guessWordList}) async {
    localStorage = await prefs;
    // Set board to
    localStorage!.setString(
      Constants.localStorageKeys.guessWordList,
      jsonEncode(guessWordList),
    );
    // localStorage!.clear();
  }

  @override
  List<BoardLetter> processGuessWord({
    required String guessWord,
    required String answerWord,
  }) {
    List<String> answerWordAsList = answerWord.toUpperCase().split('');
    List<String> guessWordAsList = guessWord.split('');
    return guessWordAsList
        // Check the right-letter-right-position ones
        .mapIndexed((index, letter) {
          // check if it is right-letter-right-position
          if (answerWordAsList[index] == letter) {
            // write off the letter of answerWord if it is checked
            answerWordAsList[index] = '-';
            return BoardLetter(
              letter: letter,
              strColor: 'pinpoint',
            );
          }
          return BoardLetter(
            letter: letter,
            strColor: 'base',
          );
        })
        .toList()
        // Then check the right-letter-wrong-position ones
        .mapIndexed((index, coloredLetter) {
          // check if the letter is in the answerWord
          // and if the letter is not green arleady
          if (answerWordAsList.contains(coloredLetter.letter) &&
              coloredLetter.color != BoardColors.pinpoint) {
            // write off the letter of answerWord if it is checked
            // by finding the index of targeted answerWord letter
            answerWordAsList[answerWordAsList.indexOf(coloredLetter.letter)] =
                '-';
            return BoardLetter(
              letter: coloredLetter.letter,
              strColor: 'okLetter',
            );
          }
          return coloredLetter;
        })
        .toList();
  }

  @override
  List<List<BoardLetter>> processGuessWordList({
    required List<String> guessWordList,
    required String answerWord,
  }) {
    return guessWordList
        .map(
          (guessWord) => processGuessWord(
            guessWord: guessWord,
            answerWord: answerWord,
          ),
        )
        .toList();
  }
}
