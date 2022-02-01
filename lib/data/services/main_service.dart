import 'dart:convert';

import 'package:scuffed_wordle/data/models/api_uri/api_uri_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MainService {
  SharedPreferences? localStorage;
  final Future<SharedPreferences> prefs;
  http.Client httpClient = http.Client();

  MainService({
    required this.prefs,
  });

  Future<http.Response> getData({
    required ApiUri apiUri,
  }) async {
    try {
      // final res = await httpClient.get(Uri.https(
      //   authority, // Main URL
      //   encodedPath, // Path
      //   queryParams, // parameters
      // ));
      final res = await httpClient.get(Uri.https(
        apiUri.baseUrl, // authority
        apiUri.route, // encodedPath
        apiUri.params, // queryParams
      ));
      // print(res);
      return res;
    } finally {
      httpClient.close();
    }
  }
}
