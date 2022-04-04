import 'package:json_annotation/json_annotation.dart';

part 'languange_model.g.dart';

@JsonSerializable()
class LanguageModel {
  String language;
  String isoCode;
  String? flag = "";

  LanguageModel({
    required this.language,
    required this.isoCode,
    required this.flag,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => _$LanguageModelFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageModelToJson(this);
}
