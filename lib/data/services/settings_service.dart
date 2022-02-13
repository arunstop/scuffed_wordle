import 'dart:convert';

import 'package:scuffed_wordle/data/constants.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/repositories/settings_repository.dart';
import 'package:scuffed_wordle/data/services/main_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends MainService implements SettingsRepo {
  final String _settingsKey = Constants.localStorageKeys.settings;
  SettingsService({
    required Future<SharedPreferences> prefs,
  }) : super(prefs: prefs);

  @override
  Future<Settings> getLocalSettings() async {
    localStorage = await prefs;
    if (localStorage!.containsKey(_settingsKey) == false) {
      return Settings();
    }

    Settings data = Settings.fromJson(
        jsonDecode(localStorage!.getString(_settingsKey).toString()));
    return data;
  }

  @override
  void setLocalSettings({required Settings settings}) async {
    // print(jsonEncode(settings.toJson()));
    localStorage = await prefs;
    localStorage!.setString(_settingsKey, jsonEncode(settings.toJson()));
    // print(Settings.fromJson(jsonDecode(jsonEncode(settings.toJson()))));
  }
}
