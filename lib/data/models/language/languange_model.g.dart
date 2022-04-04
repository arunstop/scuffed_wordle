// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'languange_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageModel _$LanguageModelFromJson(Map<String, dynamic> json) =>
    LanguageModel(
      language: json['language'] as String,
      isoCode: json['isoCode'] as String,
      flag: json['flag'] as String?,
    );

Map<String, dynamic> _$LanguageModelToJson(LanguageModel instance) =>
    <String, dynamic>{
      'language': instance.language,
      'isoCode': instance.isoCode,
      'flag': instance.flag,
    };
