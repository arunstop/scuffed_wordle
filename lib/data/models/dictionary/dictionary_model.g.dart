// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dictionary _$DictionaryFromJson(Map<String, dynamic> json) => Dictionary(
      letterCount: json['letterCount'] as int,
      wordsCount: json['wordsCount'] as int,
      answer: json['answer'] as String,
      difficulty: json['difficulty'] as String,
      answerList: (json['answerList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      wordList:
          (json['wordList'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DictionaryToJson(Dictionary instance) =>
    <String, dynamic>{
      'letterCount': instance.letterCount,
      'wordsCount': instance.wordsCount,
      'answer': instance.answer,
      'difficulty': instance.difficulty,
      'answerList': instance.answerList,
      'wordList': instance.wordList,
    };
