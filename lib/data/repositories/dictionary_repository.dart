import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/data/models/word_definition/word_model.dart';

abstract class DictionaryRepo {
  // Future<String> getLocalAnswer();
  // void setLocalAnswer({required String answer});
  Future<Dictionary> getLocalDictionary();
  void setLocalDictionary({required Dictionary dictionary});
  Future<Dictionary> getDictionary({required int length});
  Future<Word?> getWordDefinition({required String lang, required String word});
}
