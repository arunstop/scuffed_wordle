part of 'package:scuffed_wordle/bloc/board/board_bloc.dart';

// enum PostStatus { initial, success, failure }

class BoardState extends Equatable {
  final List<String> word;
  final List<List<BoardLetter>> wordList;
  final int attempt;
  final int attemptLimit;
  final bool win;

  const BoardState({
    required this.word,
    required this.wordList,
    required this.attempt,
    required this.attemptLimit,
    this.win = false,
  });

  BoardState copyWith({
    List<String>? word,
    List<List<BoardLetter>>? wordList,
    int? attempt,
    int? attemptLimit,
    bool? win,
  }) {
    return BoardState(
      word: word ?? this.word,
      wordList: wordList ?? this.wordList,
      attempt: attempt ?? this.attempt,
      attemptLimit: attemptLimit ?? this.attemptLimit,
      win: win ?? this.win,
    );
  }

  @override
  List<Object> get props =>
      [word, wordList, attempt, attemptLimit, submittedWordList];
  List<List<BoardLetter>> get submittedWordList => wordList.sublist(
      0,
      // set end index to not to go beyond wordlist Index
      // (attempt > attemptLimit ? attemptLimit : attempt),
      attempt);
  // get guesses as string
  List<String> get strGuessList => wordList
      .map((letterList) => letterList.map((letter) => letter.letter).join())
      .filter((guess)=>guess.isNotEmpty)
      .toList();
}

class BoardDefault extends BoardState {
  final List<String> word;
  final List<List<BoardLetter>> wordList;
  final int attempt;
  final int attemptLimit;
  final bool win;

  BoardDefault({
    this.word = const [],
    this.wordList = const [],
    this.attempt = 1,
    this.attemptLimit = 2,
    this.win = false,
  }) : super(
            word: word,
            wordList: wordList,
            attempt: attempt,
            attemptLimit: attemptLimit,
            win:win);
}

class BoardGameOver extends BoardState {
  final List<String> word;
  final List<List<BoardLetter>> wordList;
  final int attempt;
  final int attemptLimit;
  final bool win;
  

  BoardGameOver({
    this.word = const [],
    this.wordList = const [],
    this.attempt = 1,
    this.attemptLimit = 6,
    this.win = false,
  }) : super(
            word: word,
            wordList: wordList,
            attempt: attempt,
            attemptLimit: attemptLimit,
            win:win);
}

// class BoardEmpty extends BoardState {
//   final List<String> word;
//   final List<List<BoardLetter>> wordList;
//   final int attempt;
//   final int attemptLimit;
//   final bool win;
  

//   BoardEmpty({
//     this.word = const [],
//     this.wordList = const [],
//     this.attempt = 1,
//     this.attemptLimit = 6,
//     this.win = false,
//   }) : super(
//             word: word,
//             wordList: wordList,
//             attempt: attempt,
//             attemptLimit: attemptLimit,
//             win:win);
// }

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
