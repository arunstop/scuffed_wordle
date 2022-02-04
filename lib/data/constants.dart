import 'package:scuffed_wordle/data/models/api_uri/api_uri_model.dart';

class Constants {
  static LocalStorageKey localStorageKeys = LocalStorageKey();
  static Api api = Api();
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
      ApiScuffedWordle(baseUrl: "scuffed-wordle-api.herokuapp.com");
}

class ApiScuffedWordle extends ApiBaseURL {
  ApiScuffedWordle({required String baseUrl}) : super(baseUrl: baseUrl);

  ApiUri getWords({required Map<String, String> params}) => ApiUri(
        baseUrl: baseUrl,
        route: "/words",
        params: params,
      );
}