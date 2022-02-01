// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dictionary _$DictionaryFromJson(Map<String, dynamic> json) => Dictionary(
      letterCount: json['letterCount'] as int? ?? 0,
      wordsCount: json['wordsCount'] as int? ?? 0,
      answer: json['answer'] as String? ?? '',
      words:
          (json['words'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$DictionaryToJson(Dictionary instance) =>
    <String, dynamic>{
      'letterCount': instance.letterCount,
      'wordsCount': instance.wordsCount,
      'answer': instance.answer,
      'words': instance.words,
    };
