import 'package:equatable/equatable.dart';
import 'package:scuffed_wordle/models/model_settings.dart';

enum SettingsTypes { hardMode, darkTheme, highContrast,colorBlindMode }

class SettingsState extends Equatable {
  final bool hardMode;
  final bool darkTheme;
  final bool highContrast;  
  final bool colorBlindMode;

  SettingsState(
      {required this.hardMode,
      required this.darkTheme,
      required this.highContrast,
      required this.colorBlindMode,
      });

  SettingsState copyWith({
    bool? hardMode,
    bool? darkTheme,
    bool? highContrast,
    bool? colorBlindMode,
  }) =>
      SettingsState(
        hardMode: hardMode ?? this.hardMode,
        darkTheme: darkTheme ?? this.darkTheme,
        highContrast: highContrast ?? this.highContrast,
        colorBlindMode: colorBlindMode ?? this.colorBlindMode,
      );

  @override
  // TODO: implement props
  List<Object> get props => [hardMode, darkTheme, highContrast,colorBlindMode];
}

class SettingsInit extends SettingsState {
  SettingsInit({
    required bool hardMode,
    required bool darkTheme,
    required bool highContrast,
    required bool colorBlindMode,
  }) : super(
          hardMode: hardMode,
          darkTheme: darkTheme,
          highContrast: highContrast,
          colorBlindMode: colorBlindMode,
        );
}

class SettingsDefault extends SettingsState {
  final bool hardMode;
  final bool darkTheme;
  final bool highContrast;  
  final bool colorBlindMode;

  SettingsDefault({
    this.hardMode = false,
    this.darkTheme = false,
    this.highContrast = false,
    this.colorBlindMode = true,
  }) : super(
          hardMode: hardMode,
          darkTheme: darkTheme,
          highContrast: highContrast,
          colorBlindMode: colorBlindMode,
        );
}

// class SettingsInit extends SettingsState {
//   final List<Settings> initList;

//   SettingsInit({required this.initList}) : super(list: initList);
// }
