import 'package:scuffed_wordle/data/models/settings/settings_model.dart';

abstract class SettingsRepo {
  Future<Settings> getLocalSettings();
  void setLocalSettings({required Settings settings});
}
