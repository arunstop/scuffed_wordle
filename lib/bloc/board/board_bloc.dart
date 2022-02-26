import 'dart:async';
import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/data/models/label_model.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/models/status_model.dart';
import 'package:scuffed_wordle/data/repositories/board_repository.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:scuffed_wordle/data/repositories/settings_repository.dart';
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

  // final DictionaryBloc dictionaryBloc;
  // final SettingsBloc settingsBloc;
  // late final StreamSubscription dictionaryStream;
  // late final StreamSubscription settingsStream;
  final BoardRepo boardRepo;
  final DictionaryRepo dictionaryRepo;
  final SettingsRepo settingsRepo;

  // List<String> dictionaryList = [];
  // SettingsState settingsState = SettingsDefault(settings: Settings());
  // String keyword = "";

  BoardBloc({
    required this.boardRepo,
    required this.dictionaryRepo,
    required this.settingsRepo,
    // required this.dictionaryBloc,
    // required this.settingsBloc,
  }) : super(_boardDefault) {
    // Listen to dictionaryBloc
    // dictionaryStream = dictionaryBloc.stream.listen(_dictionaryBlocListener);
    // Listen to settingsBloc
    // settingsStream = settingsBloc.stream.listen(_settingsBlocListener);
    // Initialize board (getting user's local guess)
    on<BoardInitialize>(_onBoardInitialize);
    // Add letter whenever an alphabet key is pressed
    on<BoardAddLetter>(_onBoardAddLetter);
    // Remove letter when backspace key is pressed
    on<BoardRemoveLetter>(_onBoardRemoveLetter);
    // Add guess
    on<BoardAddGuess>(_onBoardAddGuess);
    // Submit word when enter key is pressed
    on<BoardSubmitGuess>(_onBoardSubmitGuess);
    // Restart game
    on<BoardRestart>(_onBoardRestart);
  }

  @override
  Future<void> close() {
    // dictionaryStream.cancel();
    // settingsStream.cancel();
    return super.close();
  }

  // void _dictionaryBlocListener(DictionaryState state) {
  //   // Set the word list
  //   dictionaryList = state.dictionary.wordList
  //       .map((e) => e.toLowerCase())
  //       .toList()
  //       .sortedBy((element) => element);
  //   // dictionaryList.sortedBy((element) => element);
  //   // Set the keyword
  //   keyword = state.dictionary.answer;

  //   // print(dictionaryList.toSet().map((e) => '"$e"').toList());
  // }

  // void _settingsBlocListener(SettingsState state) => settingsState = state;

  List<List<BoardLetter>> _getGameTemplate(int length, int lives) => [
        for (var i = 1; i <= lives; i++)
          [for (var i = 1; i <= length; i++) _boardLetter]
      ];

  void _onBoardInitialize(
    BoardInitialize event,
    Emitter<BoardState> emit,
  ) async {
    print('boardInit_');

    Dictionary dictionaryLocal = await dictionaryRepo.getLocalDictionary();
    Settings settingsLocal = await settingsRepo.getLocalSettings();

    int guessLength = settingsLocal.guessLength;
    int lives = settingsLocal.lives;
    String answer = dictionaryLocal.answer;
    List<List<BoardLetter>> gameTemplate =
        _getGameTemplate(guessLength, settingsLocal.lives);
    // Get guesses form users latest session (if available)
    List<List<BoardLetter>> userGuessWordList =
        await boardRepo.getLocalGuessWordList(
      answerWord: answer,
    );
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
      bool hasWon = lastGuess == answer.toLowerCase();
      // print("userAttempts : ${userAttempts}");
      // print("state.attemptLimit : ${settingsLocal.lives}");
      if (hasWon || userAttempts >= settingsLocal.lives) {
        // No need to add user attempt since the game is over
        emit(BoardGameOver(
          wordList: wordList,
          attempt: userAttempts,
          win: hasWon,
          attemptLimit: settingsLocal.lives,
        ));
        return;
      }
      // Add user attempt by 1 because the game is not over yet
      emit(_boardDefault.copyWith(
        attempt: userAttempts + 1,
        wordList: wordList,
        attemptLimit: settingsLocal.lives,
      ));
    } else {
      emit(_boardDefault.copyWith(
        wordList: gameTemplate,
        attemptLimit: settingsLocal.lives,
      ));
    }

    UiLib.showToast(
      status: Status.def,
      text: 'Good Luck!',
      duration: 3600,
      icon: Icons.emoji_emotions,
    );

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
    int wordLength = state.wordLength;
    // Count typed letters
    var typedLetters = [...state.word, event.letter];
    // if typed letters more than [matrix]
    if (typedLetters.length > wordLength) {
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

  void _onBoardAddGuess(
    BoardAddGuess event,
    Emitter<BoardState> emit,
  ) {
    if(state.word.join('') == event.guess || state is BoardGameOver){
      return;
    }
    // print('guess : ${event.guess}');
    // print('length : ${event.length}');
    // Remove spaces from guess
    emit(state.copyWith(
      word: [],
    ));
    String noSpacesGuess = event.guess.replaceAll(" ", '');
    // Check if guess has reached game word length
    int length = noSpacesGuess.length >= event.length
        ? event.length
        : noSpacesGuess.length;
    // Trim the guess by game word length
    String trimmedGuess = noSpacesGuess.substring(0, length);
    print(trimmedGuess);
    emit(state.copyWith(
      word: trimmedGuess.split(''),
    ));
    // print('length : ${length}');
    // print('nsg-length : ${noSpacesGuess.length}');
  }

  void _onBoardSubmitGuess(
    BoardSubmitGuess event,
    Emitter<BoardState> emit,
  ) async {
    // if the [current guess] length less than [matrix]
    if (state.word.length < state.wordLength) {
      UiLib.showToast(
        status: Status.error,
        text: "Not enough letter",
      );
    }
    // If user is in the hard mode and not using the green letters they found
    else {
      var strWord = state.word.join().toLowerCase();
      bool err = false;
      bool gameOver = false;
      bool retypeOnWrongGuess = event.settings.retypeOnWrongGuess == true;

      if (event.settings.hardMode == true && state.attempt > 1) {
        // Get latest answer
        List<BoardLetter> latestSubmittedWord =
            state.wordList[state.attempt - 2];
        // Process the current answer
        latestSubmittedWord.forEachIndexed((element, idx) {
          if (err == true) return;
          // Green hint should be re-used in the current answer
          if (element.color == ColorLib.tilePinpoint) {
            // if not show error and call don't proceed
            if (element.letter != state.word[idx]) {
              UiLib.showToast(
                status: Status.error,
                text: 'Letter no. ${idx + 1} must be ${element.letter}',
              );

              err = true;
            }
          }
        });
        latestSubmittedWord.forEachIndexed((element, index) {
          if (err == true) return;
          // Yellow hint should be included in the current answer
          if (element.color == ColorLib.tileOkLetter) {
            // if not show error and call don't proceed
            if (!state.word.contains(element.letter)) {
              UiLib.showToast(
                status: Status.error,
                text: 'Letter ${element.letter} must be included',
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
      if (!event.wordList.contains(strWord)) {
        UiLib.showToast(
          status: Status.error,
          text: "${strWord.toUpperCase()} is not in word list",
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
        answerWord: event.answer.toUpperCase(),
      );

      // Change wordList value based on attempt
      wordList[attempt - 1] = coloredGuess;

      // END the game if :
      // latest guess is correct OR
      // user has reached max attempt
      bool hasWon = strWord.toLowerCase() == event.answer.toLowerCase();
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
        // If user has won
        if (hasWon) {
          UiLib.showToast(
            status: Status.ok,
            text: Label.randomWinLabel,
            duration: 4800,
          );
        } else {
          UiLib.showToast(
            status: Status.error,
            text: Label.randomLoseLabel,
            duration: 4800,
          );
        }
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
        UiLib.showToast(
          status: Status.error,
          text: Label.randomLoseLabel,
          duration: 4800,
        );
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

  FutureOr<void> _onBoardRestart(
    BoardRestart event,
    Emitter<BoardState> emit,
  ) async {
    Dictionary dictionaryLocal = await dictionaryRepo.getLocalDictionary();
    Settings settingsLocal = await settingsRepo.getLocalSettings();
    boardRepo.clearLocalGuessWordList();
    // print(state.runtimeType);
    emit(_boardDefault.copyWith(
      attemptLimit: settingsLocal.lives,
      wordList:
          _getGameTemplate(settingsLocal.guessLength, settingsLocal.lives),
    ));
    // print(state.runtimeType);
    UiLib.showToast(
        status: Status.def,
        text: 'Good Luck!',
        duration: 3600,
        icon: Icons.emoji_emotions_outlined);
  }
}
