import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';

abstract class DictionaryRepo {
  // Future<String> getLocalAnswer();
  // void setLocalAnswer({required String answer});
  Future<Dictionary> getLocalDictionary();
  void setLocalDictionary({required Dictionary dictionary});
  Future<Dictionary> getDictionary({required int length});
}
