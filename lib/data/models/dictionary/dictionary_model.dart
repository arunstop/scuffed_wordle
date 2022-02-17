import 'package:json_annotation/json_annotation.dart';
import 'package:scuffed_wordle/data/models/word_definition/word_model.dart';

// enum DictionaryStatus { loaded, empty }

part 'dictionary_model.g.dart';

@JsonSerializable()
class Dictionary {
  final int letterCount;
  final int wordsCount;
  final String answer;
  final String difficulty;
  final List<String> answerList;
  final List<String> wordList;
  // final DictionaryStatus status;
  @JsonKey(ignore: true)
  final Word? wordDefinition;

  Dictionary({
    required this.letterCount,
    required this.wordsCount,
    required this.answer,
    required this.difficulty,
    required this.answerList,
    required this.wordList,
    this.wordDefinition,
  });

  Dictionary copyWith({
    int? letterCount,
    int? wordsCount,
    String? answer,
    String? difficulty,
    List<String>? answerList,
    List<String>? wordList,
    Word? wordDefinition,
  }) =>
      Dictionary(
        letterCount: letterCount ?? this.letterCount,
        wordsCount: wordsCount ?? this.wordsCount,
        answer: answer ?? this.answer,
        difficulty: difficulty ?? this.difficulty,
        answerList: answerList ?? this.answerList, 
        wordList: wordList ?? this.wordList, 
        wordDefinition: wordDefinition ?? this.wordDefinition, 
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
    String difficulty = '',
    List<String> answerList = const [],
    List<String> wordList = const [],
    Word? wordDefinition,
  }) : super(
          letterCount: letterCount,
          wordsCount: wordsCount,
          answer: answer,
          difficulty: difficulty,
          answerList: answerList,
          wordList: wordList,
          wordDefinition: wordDefinition,
        );
}
