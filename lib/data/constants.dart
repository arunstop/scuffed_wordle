import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scuffed_wordle/data/models/api_uri/api_uri_model.dart';
import 'package:encrypt/encrypt.dart';
import 'package:scuffed_wordle/data/models/language/languange_model.dart';

class Constants {
  static LocalStorageKey localStorageKeys = LocalStorageKey();
  static Api api = Api();
  // Encryption
  static EncrypterKey encrypter = EncrypterKey();
  static List<String> matrixList = [
    '4x5',
    '5x6',
    '6x7',
    '7x8',
    '8x9',
    '9x10',
    '10x11',
    '11x12',
    '12x13',
    '9x6',
    '10x6',
    '11x6',
    '12x6'
  ];
  static List<String> difficultyList = [
    'EASY',
    'NORMAL',
    'HARD',
  ];

  static Future<List<TranslationLanguage>> getLangList() async {
    // rawData returns string
    String rawData = await rootBundle
        .loadString("assets/GoogleTranslateSupportedLanguages.json");
    // Decode it with jsonDecode() into List<dynamic>
    List<dynamic> untypedLangList = jsonDecode(rawData);
    // Cast it into type TranslationLanguage
    List<TranslationLanguage> typedLangList = untypedLangList
        .map((untypedItem) => TranslationLanguage.fromJson(untypedItem))
        .toList();
    return typedLangList;
  }
}

class EncrypterKey {
  Key key32 = Key.fromUtf8("scuffed-wordle-encryption-key-32");
  IV iv = IV.fromLength(16);
}

class LocalStorageKey {
  String guessWordList = 'GUESS_WORD_LIST';
  String answer = 'ANSWER';
  String dictionary = 'DICTIONARY';
  String settings = 'SETTINGS';
}

// enum ScuffedWordleEndpoints { getWords }

class ApiBaseURL {
  final String baseUrl;

  ApiBaseURL({required this.baseUrl});
}

// GET API URLS
class Api {
  ApiScuffedWordle scuffedWordle =
      ApiScuffedWordle(baseUrl: "scuffed-wordle-api.vercel.app");
      // ApiScuffedWordle(baseUrl: "scuffed-wordle-api.cyclic.app");
      // ApiScuffedWordle(baseUrl: "scuffed-wordle-api.herokuapp.com");
  ApiFreeDictionary freeDictionary =
      ApiFreeDictionary(baseUrl: "api.dictionaryapi.dev");
}

class ApiScuffedWordle extends ApiBaseURL {
  ApiScuffedWordle({required String baseUrl}) : super(baseUrl: baseUrl);

  ApiUri getDictionary({required Map<String, String> params}) => ApiUri(
        baseUrl: baseUrl,
        route: "/dictionary",
        params: params,
      );
}

class ApiFreeDictionary extends ApiBaseURL {
  ApiFreeDictionary({required String baseUrl}) : super(baseUrl: baseUrl);

  ApiUri getWordDefinition({required String lang, required String word}) =>
      ApiUri(
        baseUrl: baseUrl,
        route: "/api/v2/entries/${lang}/${word}",
        params: {},
      );
}
