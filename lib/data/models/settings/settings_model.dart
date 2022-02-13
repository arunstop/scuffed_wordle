import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

enum SettingsTypes {
  hardMode,
  darkTheme,
  highContrast,
  colorBlindMode,
  retypeOnWrongGuess
}

@JsonSerializable()
class Settings {
  final bool hardMode;
  final bool darkTheme;
  final bool highContrast;
  final bool colorBlindMode;
  final bool retypeOnWrongGuess;

  Settings({
    this.hardMode = false,
    this.darkTheme = true,
    this.highContrast = false,
    this.colorBlindMode = false,
    this.retypeOnWrongGuess = true,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  Settings copyWith({
    bool? hardMode,
    bool? darkTheme,
    bool? highContrast,
    bool? colorBlindMode,
    bool? retypeOnWrongGuess,
  }) =>
      Settings( 
        hardMode: hardMode ?? this.hardMode,
        darkTheme: darkTheme ?? this.darkTheme,
        highContrast: highContrast ?? this.highContrast,
        colorBlindMode: colorBlindMode ?? this.colorBlindMode,
        retypeOnWrongGuess: retypeOnWrongGuess ?? this.retypeOnWrongGuess,
      );

  @override
  List<Object> get props =>
      [hardMode, darkTheme, highContrast, colorBlindMode, retypeOnWrongGuess];
}
