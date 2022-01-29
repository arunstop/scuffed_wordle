// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      hardMode: json['hardMode'] as bool,
      darkTheme: json['darkTheme'] as bool,
      highContrast: json['highContrast'] as bool,
      colorBlindMode: json['colorBlindMode'] as bool,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'hardMode': instance.hardMode,
      'darkTheme': instance.darkTheme,
      'highContrast': instance.highContrast,
      'colorBlindMode': instance.colorBlindMode,
    };
