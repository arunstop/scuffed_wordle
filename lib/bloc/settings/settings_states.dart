import 'package:equatable/equatable.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';

class SettingsState extends Equatable {
  final Settings settings;

  SettingsState({required this.settings});

  SettingsState copyWith({required Settings settings}) =>
      SettingsState(settings: settings);

  @override
  // TODO: implement props
  List<Object> get props => [settings];
}

// class SettingsInit extends SettingsState {
//   SettingsInit({required Settings settings}) : super(settings: settings);
// }

class SettingsDefault extends SettingsState {
  SettingsDefault({required Settings settings}) : super(settings: settings);
}

// class SettingsInit extends SettingsState {
//   final List<Settings> initList;

//   SettingsInit({required this.initList}) : super(list: initList);
// }
