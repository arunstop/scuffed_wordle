import 'package:equatable/equatable.dart';

class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  List<Object> get props => [];
}

class DictionaryInitialize extends DictionaryEvent {
  // final List<String> list;
  // final Function whenDone;
  // final int wordLength;

  // DictionaryInitialize({required this.wordLength});

  // @override
  // List<Object> get props => [list,keyword];
}

class DictionaryRefreshKeyword extends DictionaryEvent {
  // final String keyword;

  // DictionaryRefreshKeyword({required this.keyword});

  // @override
  // List<Object> get props => [keyword];
}

class DictionaryTest extends DictionaryEvent {}

class DictionaryDefine extends DictionaryEvent {
  // final String lang;
  // final String word;

  // DictionaryDefine({
  //   required this.lang,
  //   required this.word,
  // });
}
