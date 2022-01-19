import 'package:equatable/equatable.dart';

enum DictionaryStatus { init, success }

class DictionaryState extends Equatable {
  final List<String> list;
  final DictionaryStatus status;
  final String keyword;

  const DictionaryState(
      {this.list = const [],
      this.status = DictionaryStatus.init,
      this.keyword = ""});

  DictionaryState copyWith({
    List<String>? list,
    DictionaryStatus? status,
    String? keyword,
  }) =>
      DictionaryState(
        list: list ?? this.list,
        status: status ?? this.status,
        keyword: keyword ?? this.keyword,
      );

  @override
  List<Object> get props => [];
}
