import 'package:equatable/equatable.dart';

class DictionaryEvent  extends Equatable{
  const DictionaryEvent();

  @override
  List<Object> get props => [];
}

class DictionaryInitialize extends DictionaryEvent {
  final List<String> list;

  DictionaryInitialize({required this.list});

   @override
  List<Object> get props => [list];
}

class DictionaryRefreshKeyword extends DictionaryEvent{}