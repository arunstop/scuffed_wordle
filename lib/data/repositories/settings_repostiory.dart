import 'package:scuffed_wordle/data/models/model_settings.dart';

abstract class SettingsRepo {
  Future<Settings> getLocalSettings();
  void setLocalSettings({required Settings settings});
}
