import 'package:equatable/equatable.dart';
import 'package:scuffed_wordle/models/model_settings.dart';

enum SettingsTypes { hardMode, darkTheme, highContrast }

class SettingsState extends Equatable {
  final bool hardMode;
  final bool darkTheme;
  final bool highContrast;

  SettingsState(
      {required this.hardMode,
      required this.darkTheme,
      required this.highContrast});

  SettingsState copyWith({
    bool? hardMode,
    bool? darkTheme,
    bool? highContrast,
  }) =>
      SettingsState(
        hardMode: hardMode ?? this.hardMode,
        darkTheme: darkTheme ?? this.darkTheme,
        highContrast: highContrast ?? this.highContrast,
      );

  @override
  // TODO: implement props
  List<Object> get props => [hardMode, darkTheme, highContrast];
}

class SettingsInit extends SettingsState {
  SettingsInit({
    required bool hardMode,
    required bool darkTheme,
    required bool highContrast,
  }) : super(
          hardMode: hardMode,
          darkTheme: darkTheme,
          highContrast: highContrast,
        );
}

// class SettingsDefault extends SettingsState {
//   SettingsDefault()
//       : super(
//           hardMode: false,
//           darkTheme: false,
//           highContrast: false,
//         );
// }

// class SettingsInit extends SettingsState {
//   final List<Settings> initList;

//   SettingsInit({required this.initList}) : super(list: initList);
// }
