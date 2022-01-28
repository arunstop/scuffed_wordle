abstract class DictionaryRepo {
  Future<List<String>> getKeywordList();
  Future<List<String>> getValidWordList();
}
