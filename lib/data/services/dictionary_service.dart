import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scuffed_wordle/data/constants.dart';
import 'package:scuffed_wordle/data/models/api_uri/api_uri_model.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:scuffed_wordle/data/services/main_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DictionaryService extends MainService implements DictionaryRepo {
  final String _answerKey = Constants.localStorageKeys.answer;
  final String _dictionaryKey = Constants.localStorageKeys.dictionary;
  DictionaryService({
    required Future<SharedPreferences> prefs,
  }) : super(prefs: prefs);

  // @override
  // Future<String> getLocalAnswer() async {
  //   localStorage = await prefs;
  //   // Check if answer already in local storage
  //   if (localStorage!.containsKey(_answerKey) == false) {
  //     return '';
  //   }
  //   String data = localStorage!.getString(_answerKey).toString();
  //   return data;
  // }

  // @override
  // void setLocalAnswer({required String answer}) async {
  //   localStorage = await prefs;
  //   localStorage!.setString(_answerKey, answer);
  // }

  @override
  Future<Dictionary> getLocalDictionary() async {
    localStorage = await prefs;
    if (localStorage!.containsKey(_dictionaryKey)) {
      Dictionary data = Dictionary.fromJson(jsonDecode(
        localStorage!.getString(_dictionaryKey).toString(),
      ));
      return data;
    }
    return DictionaryEmpty();
  }

  @override
  void setLocalDictionary({required Dictionary dictionary}) async {
    localStorage = await prefs;
    // set to local disk
    localStorage!.setString(_dictionaryKey, jsonEncode(dictionary.toJson()));
  }

  @override
  Future<Dictionary> getDictionary({required int length}) async {
    http.Response getGameDictionary = await getData(
      apiUri: Constants.api.scuffedWordle.getWords(
        params: {
          "length": "5",
        },
      ),
    );
    if (getGameDictionary.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Dictionary.fromJson(jsonDecode(getGameDictionary.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return throw Exception('Failed to load album');
    }
  }
}
