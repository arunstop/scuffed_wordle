import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scuffed_wordle/data/constants.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DictionaryService implements DictionaryRepo {
  final Future<SharedPreferences> prefs;
  SharedPreferences? localStorage;
  final String _answerKey = Constants.localStorageKeys.answer;
  DictionaryService({
    required this.prefs,
  });

  @override
  Future<List<String>> getKeywordList() async {
    String rawDataList =
        await rootBundle.loadString("assets/5LettersOxford5000.json");
    List<dynamic> dataList = jsonDecode(rawDataList);
    return dataList.map((e) => e.toString()).toList();
  }

  @override
  Future<List<String>> getValidWordList() async {
    String rawDataList =
        await rootBundle.loadString("assets/5LetterWordList.json");
    List<dynamic> dataList = jsonDecode(rawDataList);
    return dataList.map((e) => e.toString()).toList();
  }

  @override
  void setLocalAnswer({required String answer}) async {
    localStorage = await prefs;
    localStorage!.setString(_answerKey, answer);
  }

  @override
  Future<String> getLocalAnswer() async {
    localStorage = await prefs;
    // Check if answer already in local storage
    if (localStorage!.containsKey(_answerKey) == false) {
      return '';
    }
    String data = localStorage!.getString(_answerKey).toString();
    return data;
  }
}
