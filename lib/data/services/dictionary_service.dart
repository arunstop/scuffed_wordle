import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';

class DictionaryService implements DictionaryRepo {
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
}
