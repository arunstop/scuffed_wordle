import 'dart:async';
import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_states.dart';
import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/repositories/board_repository.dart';
import 'package:scuffed_wordle/ui.dart';
part 'package:scuffed_wordle/bloc/board/board_events.dart';
part 'package:scuffed_wordle/bloc/board/board_states.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  static final BoardLetter _boardLetter =
      BoardLetter(letter: '', strColor: 'base');

  // static const _initWord = ['', '', '', '', ''];
  static const List<String> _initWord = [];

  static final BoardDefault _boardDefault = BoardDefault();
  // BoardDefault(word: _initWord, wordList: _initWordList);

  final DictionaryBloc dictionaryBloc;
  final SettingsBloc settingsBloc;
  late final StreamSubscription dictionaryStream;
  late final StreamSubscription settingsStream;
  final BoardRepo boardRepo;

  List<String> dictionaryList = [];
  SettingsState settingsState = SettingsDefault(settings: Settings());
  String keyword = "";

  BoardBloc({
    required this.boardRepo,
    required this.dictionaryBloc,
    required this.settingsBloc,
  }) : super(_boardDefault) {
    // Listen to dictionaryBloc
    dictionaryStream = dictionaryBloc.stream.listen(_dictionaryBlocListener);
    // Listen to settingsBloc
    settingsStream = settingsBloc.stream.listen(_settingsBlocListener);
    // Initialize board (getting user's local guess)
    on<BoardInitialize>(_onBoardInitialize);
    // Add letter whenever an alphabet key is pressed
    on<BoardAddLetter>(_onBoardAddLetter);
    // Remove letter when backspace key is pressed
    on<BoardRemoveLetter>(_onBoardRemoveLetter);
    // Submit word when enter key is pressed
    on<BoardSubmitGuess>(_onBoardSubmitGuess);
    // Restart game
    on<BoardRestart>(_onBoardRestart);
  }

  @override
  Future<void> close() {
    dictionaryStream.cancel();
    settingsStream.cancel();
    return super.close();
  }

  void _dictionaryBlocListener(DictionaryState state) {
    // Set the word list
    dictionaryList = state.dictionary.wordList
        .map((e) => e.toLowerCase())
        .toList()
        .sortedBy((element) => element);
    // dictionaryList.sortedBy((element) => element);
    // Set the keyword
    keyword = state.dictionary.answer;

    // print(dictionaryList.toSet().map((e) => '"$e"').toList());
  }

  void _settingsBlocListener(SettingsState state) => settingsState = state;

  List<List<BoardLetter>> _getGameTemplate(int length, int lives) => [
        for (var i = 1; i <= lives; i++)
          [for (var i = 1; i <= length; i++) _boardLetter]
      ];

  void _onBoardInitialize(
    BoardInitialize event,
    Emitter<BoardState> emit,
  ) async {
    List<List<BoardLetter>> gameTemplate =
        _getGameTemplate(event.length, event.lives);
    // Get guesses form users latest session (if available)
    List<List<BoardLetter>> userGuessWordList =
        await boardRepo.getLocalGuessWordList(
            answerWord: dictionaryBloc.state.dictionary.answer);
    // print(userGuessWordList.map((e) => e.map((e) => e.letter).join()));

    // If user has played before.
    if (userGuessWordList.isNotEmpty) {
      // Get how many did user attempted
      int userAttempts = userGuessWordList.length;
      // Check if user's guesses were enough to make the game ends
      // By checking if user's attempt has reached the limit or not
      // Or by checking the latest guess is the answer
      // Add user's guesses to the board
      List<List<BoardLetter>> wordList = [
        ...userGuessWordList,
        ...gameTemplate.drop(userGuessWordList.length)
      ];
      String lastGuess =
          userGuessWordList.last.map((e) => e.letter).join().toLowerCase();
      bool hasWon =
          lastGuess == dictionaryBloc.state.dictionary.answer.toLowerCase();
      if (hasWon || userAttempts >= state.attemptLimit) {
        // No need to add user attempt since the game is over
        emit(BoardGameOver(
          wordList: wordList,
          attempt: userAttempts,
          win: hasWon,
          attemptLimit: event.lives,
        ));
        return;
      }
      // Add user attempt by 1 because the game is not over yet
      emit(_boardDefault.copyWith(
        attempt: userAttempts + 1,
        wordList: wordList,
        attemptLimit: event.lives,
      ));
    } else {
      emit(_boardDefault.copyWith(
        wordList: gameTemplate,
        attemptLimit: event.lives,
      ));
    }

    // dictionaryBloc.add(
    //     DictionaryDefine(
    //       lang: 'en',
    //       word: dictionaryBloc.state.dictionary.answer,
    //     ),
    //   );
    // dictionaryStream.cancel();
  }

  void _onBoardAddLetter(
    BoardAddLetter event,
    Emitter<BoardState> emit,
  ) {
    // Count typed letters
    var typedLetters = [...state.word, event.letter];
    // if typed letters is 5 or more, do nothing
    if (typedLetters.length > 5) {
      return;
    }
    // Apply changes on the bloc
    emit(state.copyWith(
      word: typedLetters,
    ));
  }

  void _onBoardRemoveLetter(
    BoardRemoveLetter event,
    Emitter<BoardState> emit,
  ) {
    // Count typed letters
    var typedLetters = [...state.word];
    // Proceed if the word is not empty
    if (typedLetters.isEmpty) {
      return;
    }
    // Remove the last letter
    typedLetters.removeLast();
    // Apply changes on the bloc
    emit(state.copyWith(word: typedLetters));
  }

  void _onBoardSubmitGuess(
    BoardSubmitGuess event,
    Emitter<BoardState> emit,
  ) async {
    // print((await boardRepo.getLocalGuessWordList(
    //         answerWord: dictionaryBloc.state.dictionary.answer))
    //     .map((e) => e.map((e) => e.letter).join()));
    // Submit word when the count is 5 letter
    if (state.word.length < 5) {
      Fluttertoast.showToast(
        msg: "Not enough letter",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        webPosition: 'center',
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        webBgColor: ColorList.strError,
        textColor: Colors.white,
      );
    }
    // If user is in the hard mode and not using the green letters they found
    else {
      var strWord = state.word.join().toLowerCase();
      bool err = false;
      bool gameOver = false;
      bool retypeOnWrongGuess =
          settingsState.settings.retypeOnWrongGuess == true;

      if (settingsState.settings.hardMode == true && state.attempt > 1) {
        // Get latest answer
        List<BoardLetter> latestSubmittedWord =
            state.wordList[state.attempt - 2];
        // Process the current answer
        latestSubmittedWord.forEachIndexed((element, idx) {
          if (err == true) return;
          // Green hint should be re-used in the current answer
          if (element.color == ColorList.tilePinpoint) {
            // if not show error and call don't proceed
            if (element.letter != state.word[idx]) {
              UiLib.showToast(
                title: 'Letter no. ${idx + 1} must be ${element.letter}',
                strColor: ColorList.strError,
              );
              err = true;
            }
          }
        });
        latestSubmittedWord.forEachIndexed((element, index) {
          if (err == true) return;
          // Yellow hint should be included in the current answer
          if (element.color == ColorList.tileOkLetter) {
            // if not show error and call don't proceed
            if (!state.word.contains(element.letter)) {
              UiLib.showToast(
                title: 'Letter ${element.letter} must be included',
                strColor: ColorList.strError,
              );
              err = true;
            }
          }
        });
        if (err == true) {
          // reset current guess if the retypeOnWrongGuess setting is on
          if (retypeOnWrongGuess) {
            emit(state.copyWith(word: []));
          }
          return;
        }
      }
      // If the word is not in word list
      if (!dictionaryList.contains(strWord)) {
        UiLib.showToast(
          title: "${strWord.toUpperCase()} is not in word list",
          strColor: ColorList.strError,
        );
        if (retypeOnWrongGuess) {
          emit(state.copyWith(word: []));
        }
        return;
      }
      // Copy the wordList state value
      var wordList = [...state.wordList];
      // Change the value based on index/attempt
      var attempt = state.attempt;

      // Process the typed word
      List<BoardLetter> coloredGuess = boardRepo.processGuessWord(
        guessWord: state.word.join().toUpperCase(),
        answerWord: keyword.toUpperCase(),
      );

      // Change wordList value based on attempt
      wordList[attempt - 1] = coloredGuess;

      // END the game if :
      // latest guess is correct OR
      // user has reached max attempt
      bool hasWon = strWord.toLowerCase() == keyword.toLowerCase();
      if (hasWon || state.attempt >= state.attemptLimit) {
        // Not adding attempt if user guessed it right
        // var attempt = strWord.toLowerCase() == keyword.toLowerCase()
        //     ? state.attempt - 1
        //     : state.attempt;
        // Apply changes tot the bloc
        emit(BoardGameOver(
          wordList: wordList,
          attempt: state.attempt,
          win: hasWon,
        ));
        // Show the keyword
        UiLib.showToast(
          title: keyword.toUpperCase(),
          strColor: ColorList.strOk,
        );
        gameOver = true;
      }
      // END THE GAME
      // if user entered the same word they already did.
      // meaning they gave up
      else if (state.strGuessList.contains(strWord.toUpperCase())) {
        print('same word entered, game over');
        // change the empty board guesses with current guess
        wordList = state.wordList.map((letterList) {
          // check if a row is empty
          String letter = letterList.map((e) => e.letter).join().toLowerCase();
          // if it is, then
          // change the current row, with current guess
          if (letter.isEmpty) {
            return coloredGuess;
          }
          return letterList;
        }).toList();
        // apply changes
        emit(BoardGameOver(
          wordList: wordList,
          attempt: state.attemptLimit,
          win: false,
        ));
        gameOver = true;
      }
      // if game is not over
      // keep adding the guesses
      else {
        // Apply changes on the bloc
        emit(state.copyWith(
          word: _initWord,
          wordList: wordList,
          attempt: attempt + 1,
        ));
      }
      // // If the game is over,
      // // No need to cut the submittedWordList by 1
      // List<List<BoardLetter>> submittedGuessWordList =
      //     state.submittedWordList.dropLast(gameOver ? 0 : 1);
      // // Saving list of guess words typed by user
      // // By turn List<List<BoardLetter>> to List<String>
      // List<String> guessWordList = submittedGuessWordList
      //     .map((e) => e.map((e) => e.letter).join(''))
      //     .toList();
      boardRepo.setLocalGuessWordList(guessWordList: state.strGuessList);
      // print((await boardRepo.getLocalGuessWordList(
      //         answerWord: dictionaryBloc.state.dictionary.answer))
      //     .map((e) => e.map((e) => e.letter).join()));
    }
  }

  void _onBoardRestart(
    BoardRestart event,
    Emitter<BoardState> emit,
  ) {
    boardRepo.clearLocalGuessWordList();
    print(state.runtimeType);
    emit(_boardDefault.copyWith(
      attemptLimit: event.lives,
      wordList: _getGameTemplate(event.length, event.lives),
    ));
    print(state.runtimeType);
  }
}
