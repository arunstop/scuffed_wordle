import 'package:json_annotation/json_annotation.dart';

part 'definition_model.g.dart';
@JsonSerializable()
class Definition {
  Definition({
    required this.definition,
    required this.example,
  });
  
  @JsonKey(includeIfNull: true)
  final String definition;
  @JsonKey(includeIfNull: true)
  final String example;


  Definition copyWith({
    String? definition,
    String? example,
  }) =>
      Definition(
        definition: definition ?? this.definition,
        example: example ?? this.example,
      );

   factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionToJson(this);
}