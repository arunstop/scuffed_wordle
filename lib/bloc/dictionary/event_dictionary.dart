class DictionaryEvent {}

class DictionaryInit extends DictionaryEvent {
  final List<String> list;

  DictionaryInit({required this.list});
}
