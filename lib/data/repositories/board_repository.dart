import 'package:scuffed_wordle/data/models/model_board_letter.dart';

abstract class BoardRepo {
  Future<List<List<BoardLetter>>> getSessionBoard();
  void setSessionBoard({required List<List<BoardLetter>> list});
}
