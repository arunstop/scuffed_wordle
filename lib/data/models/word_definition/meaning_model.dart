import 'package:json_annotation/json_annotation.dart';
import 'package:scuffed_wordle/data/models/word_definition/definition_model.dart';

part 'meaning_model.g.dart';

@JsonSerializable()
class Meaning {
  Meaning({
    required this.partOfSpeech,
    required this.definitions,
  });

  final String? partOfSpeech;
  final List<Definition>? definitions;

  Meaning copyWith({
    String? partOfSpeech,
    List<Definition>? definitions,
  }) =>
      Meaning(
        partOfSpeech: partOfSpeech ?? this.partOfSpeech,
        definitions: definitions ?? this.definitions,
      );
      
  factory Meaning.fromJson(Map<String, dynamic> json) =>
      _$MeaningFromJson(json);

  Map<String, dynamic> toJson() => _$MeaningToJson(this);
}
