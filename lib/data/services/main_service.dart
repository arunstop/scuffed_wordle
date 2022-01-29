import 'package:shared_preferences/shared_preferences.dart';

class MainService {
  SharedPreferences? localStorage;
  final Future<SharedPreferences> prefs;

  MainService({
    required this.prefs,
  });
}
