import 'package:equatable/equatable.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';

enum DictionaryStateStatus {
  init,
  loading,
  ok,
  error,
}

class DictionaryState extends Equatable {
  const DictionaryState({
    required this.dictionary,
    this.status = DictionaryStateStatus.init,
  });

  final Dictionary dictionary;
  final DictionaryStateStatus status;

  DictionaryState copyWith({
    required Dictionary dictionary,
    DictionaryStateStatus? status,
  }) =>
      DictionaryState(
        dictionary: dictionary,
        status: status ?? this.status,
      );

  DictionaryState statusInit({Dictionary? dictionary}) => DictionaryState(
        dictionary: dictionary ?? this.dictionary,
        status: DictionaryStateStatus.init,
      );
  DictionaryState statusLoading({Dictionary? dictionary}) => DictionaryState(
        dictionary: dictionary ?? this.dictionary,
        status: DictionaryStateStatus.loading,
      );
  DictionaryState statusOk({Dictionary? dictionary}) => DictionaryState(
        dictionary: dictionary ?? this.dictionary,
        status: DictionaryStateStatus.ok,
      );
      DictionaryState statusError({Dictionary? dictionary}) => DictionaryState(
        dictionary: dictionary ?? this.dictionary,
        status: DictionaryStateStatus.error,
      );

  @override
  List<Object> get props => [dictionary, status];
}

class DictionaryDefault extends DictionaryState {
  const DictionaryDefault({required Dictionary dictionary})
      : super(dictionary: dictionary);
}

// class DictionaryDefineLoading extends DictionaryState {
//   const DictionaryDefineLoading({required Dictionary dictionary})
//       : super(dictionary: dictionary);
// }
