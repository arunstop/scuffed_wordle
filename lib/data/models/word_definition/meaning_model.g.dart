// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meaning_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meaning _$MeaningFromJson(Map<String, dynamic> json) => Meaning(
      partOfSpeech: json['partOfSpeech'] as String,
      definitions: (json['definitions'] as List<dynamic>)
          .map((e) => Definition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeaningToJson(Meaning instance) => <String, dynamic>{
      'partOfSpeech': instance.partOfSpeech,
      'definitions': instance.definitions,
    };
