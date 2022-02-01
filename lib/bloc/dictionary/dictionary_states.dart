import 'package:equatable/equatable.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';

enum DictionaryStatus { init, success }

class DictionaryState extends Equatable {
  final Dictionary dictionary;
  const DictionaryState({required this.dictionary});

  DictionaryState copyWith({required Dictionary dictionary}) =>
      DictionaryState(dictionary: dictionary);

  @override
  List<Object> get props => [dictionary];
}

class DictionaryDefault extends DictionaryState {
  const DictionaryDefault({required Dictionary dictionary})
      : super(dictionary: dictionary);
}
