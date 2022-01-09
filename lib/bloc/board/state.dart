part of 'package:scuffed_wordle/bloc/board/bloc.dart';

// enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  const PostState({
    this.posts = const <String>[],
    this.hasReachedMax = false,
  });

  final List<String> posts;
  final bool hasReachedMax;

  PostState copyWith({
    List<String>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax];
}

class BoardState extends Equatable {
  final List<String> word;

  const BoardState({this.word = const []});

  BoardState copywith({List<String>? word}) {
    return BoardState(word: word ?? this.word);
  }

  @override
  List<Object> get props => [word];
}

class BoardInit extends BoardState {
  final List<String> word;

  BoardInit({required this.word}) : super(word: word);
}

// class BoardValue extends BoardState {
//   final String word;
//   BoardValue({
//     required this.word,
//   }) : super(word: word);
// }

// class BoardInitial extends BoardState{
//   const BoardInitial(String word) :super(word);

//   @override
//   String toString() {
//     // TODO: implement toString
//     return super.toString();
//   }
// }
