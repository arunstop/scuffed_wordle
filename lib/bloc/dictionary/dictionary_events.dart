import 'package:equatable/equatable.dart';

class DictionaryEvent extends Equatable {
  const DictionaryEvent();

  @override
  List<Object> get props => [];
}

class DictionaryInitialize extends DictionaryEvent {
  final List<String> list;
  final String keyword;

  DictionaryInitialize({required this.list, required this.keyword});

  @override
  List<Object> get props => [list,keyword];
}

class DictionaryRefreshKeyword extends DictionaryEvent {
  final String keyword;

  DictionaryRefreshKeyword({required this.keyword});

  @override
  List<Object> get props => [keyword];
}
