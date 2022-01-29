abstract class DictionaryRepo {
  Future<List<String>> getKeywordList();
  Future<List<String>> getValidWordList();
  Future<String> getLocalAnswer();
  void setLocalAnswer({required String answer});
}
