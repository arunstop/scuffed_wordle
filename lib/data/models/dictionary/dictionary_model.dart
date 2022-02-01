import 'package:json_annotation/json_annotation.dart';

// enum DictionaryStatus { loaded, empty }

part 'dictionary_model.g.dart';

// @JsonSerializable()
class Dictionary {
  final int letterCount;
  final int wordsCount;
  final String answer;
  final List<String> words;
  // final DictionaryStatus status;

  Dictionary({
    required this.letterCount,
    required this.wordsCount,
    required this.answer,
    required this.words,
  });

  Dictionary copyWith({
    int? letterCount,
    int? wordsCount,
    String? answer,
    List<String>? words,
  }) =>
      Dictionary(
        letterCount: letterCount ?? this.letterCount,
        wordsCount: wordsCount ?? this.wordsCount,
        answer: answer ?? this.answer,
        words: words ?? this.words,
      );

  factory Dictionary.fromJson(Map<String, dynamic> json) =>
      _$DictionaryFromJson(json);

  Map<String, dynamic> toJson() => _$DictionaryToJson(this);
}

class DictionaryEmpty extends Dictionary {
  DictionaryEmpty({
    int letterCount = 0,
    int wordsCount = 0,
    String answer = '',
    List<String> words = const [],
  }) : super(
          letterCount: letterCount,
          wordsCount: wordsCount,
          answer: answer,
          words: words,
        );
}
