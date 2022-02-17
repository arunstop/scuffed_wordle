import 'package:json_annotation/json_annotation.dart';

part 'definition_model.g.dart';
@JsonSerializable()
class Definition {
  Definition({
    required this.definition,
    required this.synonyms,
    required this.antonyms,
  });

  final String definition;
  final List<String> synonyms;
  final List<String> antonyms;

  Definition copyWith({
    String? definition,
    List<String>? synonyms,
    List<String>? antonyms,
  }) =>
      Definition(
        definition: definition ?? this.definition,
        synonyms: synonyms ?? this.synonyms,
        antonyms: antonyms ?? this.antonyms,
      );

   factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionToJson(this);
}