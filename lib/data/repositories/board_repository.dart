import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';

abstract class BoardRepo {
  Future<List<List<BoardLetter>>> getLocalGuessWordList({required String answerWord});
  void setLocalGuessWordList({
    required List<String> guessWordList,
  });
  void clearLocalGuessWordList();
  List<BoardLetter> processGuessWord({
    required String guessWord,
    required String answerWord,
  });
  List<List<BoardLetter>> processGuessWordList({
    required List<String> guessWordList,
    required String answerWord,
  });
}
