import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

enum SettingsTypes {
  hardMode,
  darkTheme,
  highContrast,
  colorBlindMode,
  retypeOnWrongGuess,
  useMobileKeyboard,
  wordLength,
}

@JsonSerializable()
class Settings {
  final bool hardMode;
  final bool darkTheme;
  final bool highContrast;
  final bool colorBlindMode;
  final bool retypeOnWrongGuess;
  final bool useMobileKeyboard;
  final String wordLength;

  Settings({
    this.hardMode = false,
    this.darkTheme = true,
    this.highContrast = false,
    this.colorBlindMode = false,
    this.retypeOnWrongGuess = true,
    this.useMobileKeyboard = false,
    this.wordLength = '5x6',
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  int get guessLength => int.parse(wordLength[0]);
  int get lives => guessLength+1;

  Settings copyWith({
    bool? hardMode,
    bool? darkTheme,
    bool? highContrast,
    bool? colorBlindMode,
    bool? retypeOnWrongGuess,
    bool? useMobileKeyboard,
    String? wordLength,
  }) =>
      Settings( 
        hardMode: hardMode ?? this.hardMode,
        darkTheme: darkTheme ?? this.darkTheme,
        highContrast: highContrast ?? this.highContrast,
        colorBlindMode: colorBlindMode ?? this.colorBlindMode,
        retypeOnWrongGuess: retypeOnWrongGuess ?? this.retypeOnWrongGuess,
        useMobileKeyboard: useMobileKeyboard ?? this.useMobileKeyboard,
        wordLength: wordLength ?? this.wordLength,
      );

  // @override
  // List<Object> get props =>
  //     [hardMode, darkTheme, highContrast, colorBlindMode, retypeOnWrongGuess,useMobileKeyboard];
}
