import 'package:equatable/equatable.dart';

enum DictionaryStatus { init, success }

class DictionaryState extends Equatable {
  final List<String> list;
  final String keyword;

  const DictionaryState(
      {this.list = const [],
      this.keyword = ""});

  DictionaryState copyWith({
    List<String>? list,
    String? keyword,
  }) =>
      DictionaryState(
        list: list ?? this.list,
        keyword: keyword ?? this.keyword,
      );

  @override
    List<Object> get props => [list,keyword];
}

class DictionaryDefault extends DictionaryState {
  final List<String> list;
  final String keyword;

  const DictionaryDefault({
    this.list = const [],
    this.keyword = "",
  }) : super(
          list: list,
          keyword: keyword,
        );
}
