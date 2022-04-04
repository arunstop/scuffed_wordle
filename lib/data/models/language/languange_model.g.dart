// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'languange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslationLanguage _$TranslationLanguageFromJson(Map<String, dynamic> json) =>
    TranslationLanguage(
      language: json['language'] as String,
      isoCode: json['isoCode'] as String,
      flag: json['flag'] as String?,
    );

Map<String, dynamic> _$TranslationLanguageToJson(
        TranslationLanguage instance) =>
    <String, dynamic>{
      'language': instance.language,
      'isoCode': instance.isoCode,
      'flag': instance.flag,
    };
