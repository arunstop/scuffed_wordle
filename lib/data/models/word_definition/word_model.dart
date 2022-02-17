import 'package:json_annotation/json_annotation.dart';
import 'package:scuffed_wordle/data/models/word_definition/phonetic_model.dart';

import 'meaning_model.dart';

part 'word_model.g.dart';

@JsonSerializable()
class Word {
  Word({
    required this.word,
    required this.phonetic,
    required this.phonetics,
    // required this.origin,
    required this.meanings,
  });

  @JsonKey(includeIfNull: true)
  final String word;
  @JsonKey(includeIfNull: true)
  final String phonetic;
  @JsonKey(includeIfNull: true)
  final List<Phonetic> phonetics;
  // final String origin;
  @JsonKey(includeIfNull: true)
  final List<Meaning> meanings;

  Word copyWith({
    String? word,
    String? phonetic,
    List<Phonetic>? phonetics,
    // String? origin,
    List<Meaning>? meanings,
  }) =>
      Word(
        word: word ?? this.word,
        phonetic: phonetic ?? this.phonetic,
        phonetics: phonetics ?? this.phonetics,
        // origin: origin ?? this.origin,
        meanings: meanings ?? this.meanings,
      );

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  Map<String, dynamic> toJson() => _$WordToJson(this);
}
