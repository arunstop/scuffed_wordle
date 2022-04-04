import 'package:json_annotation/json_annotation.dart';

part 'languange_model.g.dart';

@JsonSerializable()
class TranslationLanguage {
  String language;
  String isoCode;
  String? flag = "";

  TranslationLanguage({
    required this.language,
    required this.isoCode,
    required this.flag,
  });

  factory TranslationLanguage.fromJson(Map<String, dynamic> json) =>
      _$TranslationLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$TranslationLanguageToJson(this);
}
