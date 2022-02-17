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
      retypeOnWrongGuess: json['retypeOnWrongGuess'] as bool? ?? true,
      useMobileKeyboard: json['useMobileKeyboard'] as bool? ?? false,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'hardMode': instance.hardMode,
      'darkTheme': instance.darkTheme,
      'highContrast': instance.highContrast,
      'colorBlindMode': instance.colorBlindMode,
      'retypeOnWrongGuess': instance.retypeOnWrongGuess,
      'useMobileKeyboard': instance.useMobileKeyboard,
    };
