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
  matrix,
  difficulty,
  translationLanguage
}

@JsonSerializable()
class Settings {
  final bool hardMode;
  final bool darkTheme;
  final bool highContrast;
  final bool colorBlindMode;
  final bool retypeOnWrongGuess;
  final bool useMobileKeyboard;
  final String matrix;
  final String difficulty;
  final String translationLanguage;

  Settings({
    this.hardMode = false,
    this.darkTheme = true,
    this.highContrast = false,
    this.colorBlindMode = false,
    this.retypeOnWrongGuess = false,
    this.useMobileKeyboard = false,
    this.matrix = '5x6',
    this.difficulty = 'EASY',
    this.translationLanguage = 'en',
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  int get guessLength => int.parse(matrix.split("x")[0]);
  int get lives => int.parse(matrix.split("x")[1]);

  Settings copyWith({
    bool? hardMode,
    bool? darkTheme,
    bool? highContrast,
    bool? colorBlindMode,
    bool? retypeOnWrongGuess,
    bool? useMobileKeyboard,
    String? matrix,
    String? difficulty,
    String? translationLanguage,
  }) =>
      Settings(
        hardMode: hardMode ?? this.hardMode,
        darkTheme: darkTheme ?? this.darkTheme,
        highContrast: highContrast ?? this.highContrast,
        colorBlindMode: colorBlindMode ?? this.colorBlindMode,
        retypeOnWrongGuess: retypeOnWrongGuess ?? this.retypeOnWrongGuess,
        useMobileKeyboard: useMobileKeyboard ?? this.useMobileKeyboard,
        matrix: matrix ?? this.matrix,
        difficulty: difficulty ?? this.difficulty,
        translationLanguage: translationLanguage ?? this.translationLanguage,
      );

  // @override
  // List<Object> get props =>
  //     [hardMode, darkTheme, highContrast, colorBlindMode, retypeOnWrongGuess,useMobileKeyboard];
}
