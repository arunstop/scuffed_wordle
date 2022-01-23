import 'package:equatable/equatable.dart';
import 'package:scuffed_wordle/models/model_settings.dart';

enum SettingsTypes { darkTheme, highContrast }

class SettingsState extends Equatable {
  final bool darkTheme;
  final bool highContrast;

  SettingsState({required this.darkTheme, required this.highContrast});

  SettingsState copyWith({
    bool? darkTheme,
    bool? highContrast,
  }) =>
      SettingsState(
        darkTheme: darkTheme ?? this.darkTheme,
        highContrast: highContrast ?? this.highContrast,
      );

  @override
  // TODO: implement props
  List<Object> get props => [darkTheme, highContrast];
}

class SettingsDefault extends SettingsState {
  SettingsDefault()
      : super(
          darkTheme: false,
          highContrast: false,
        );
}

// class SettingsInit extends SettingsState {
//   final List<Settings> initList;

//   SettingsInit({required this.initList}) : super(list: initList);
// }
