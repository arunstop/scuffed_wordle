import 'package:scuffed_wordle/data/models/model_dictionary.dart';

abstract class DictionaryRepo {
  Future<String> getLocalAnswer();
  Future<Dictionary> getLocalDictionary();
  void setLocalAnswer({required String answer});
  Future<Dictionary> getDictionary({required int length});
}
