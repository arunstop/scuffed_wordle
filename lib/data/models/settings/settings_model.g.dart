// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      hardMode: json['hardMode'] as bool? ?? false,
      darkTheme: json['darkTheme'] as bool? ?? true,
      highContrast: json['highContrast'] as bool? ?? false,
      colorBlindMode: json['colorBlindMode'] as bool? ?? false,
      retypeOnWrongGuess: json['retypeOnWrongGuess'] as bool? ?? false,
      useMobileKeyboard: json['useMobileKeyboard'] as bool? ?? false,
      matrix: json['matrix'] as String? ?? '5x6',
      difficulty: json['difficulty'] as String? ?? 'EASY',
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'hardMode': instance.hardMode,
      'darkTheme': instance.darkTheme,
      'highContrast': instance.highContrast,
      'colorBlindMode': instance.colorBlindMode,
      'retypeOnWrongGuess': instance.retypeOnWrongGuess,
      'useMobileKeyboard': instance.useMobileKeyboard,
      'matrix': instance.matrix,
      'difficulty': instance.difficulty,
    };
