
import 'package:json_annotation/json_annotation.dart';

part 'phonetic_model.g.dart';
@JsonSerializable()
class Phonetic {
  Phonetic({
    required this.text,
    required this.audio,
  });

  final String text;
  final String audio;

  Phonetic copyWith({
    String? text,
    String? audio,
  }) =>
      Phonetic(
        text: text ?? this.text,
        audio: audio ?? this.audio,
      );
       factory Phonetic.fromJson(Map<String, dynamic> json) =>
      _$PhoneticFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneticToJson(this);
}