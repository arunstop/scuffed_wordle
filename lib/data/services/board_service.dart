import 'dart:convert';

import 'package:scuffed_wordle/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:scuffed_wordle/data/models/model_board_letter.dart';
import 'package:scuffed_wordle/data/repositories/board_repository.dart';

class BoardService implements BoardRepo {
  SharedPreferences prefs;
  BoardService({
    required this.prefs,
  });

  @override
  Future<List<List<BoardLetter>>> getSessionBoard() async {
    List rawData = jsonDecode(
        prefs.getString(Constants.localStorageKeys.boardWordList).toString());
    List<List<BoardLetter>> data = List<List<BoardLetter>>.from(rawData
        .map((row) => row.map((col) => BoardLetter.fromJson(col)))
        .toList());

    return [];
  }

  @override
  void setSessionBoard({required List<List<BoardLetter>> list}) {
    var value = list.map((row) => row.map((col) => col.toJson()));
    prefs.setString(
        Constants.localStorageKeys.boardWordList, jsonEncode(value));
  }
}
