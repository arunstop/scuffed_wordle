import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';

class Helpers {
  static String stringifyMatrixRow(List<BoardLetter> letterList) {
    return letterList.map((e) => e.letter).toList().join("");
  }

  static List<String> diffi2cultyList = [
    'EASY',
    'NORMAL',
    'HARD',
  ];
}
