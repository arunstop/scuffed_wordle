part of 'board_bloc.dart';

abstract class BoardState extends Equatable {
  final String word;
  const BoardState({required this.word});
  @override
  List<Object> get props => [word];
}

// class BoardInitial extends BoardState{
//   const BoardInitial(String word) :super(word);

//   @override
//   String toString() {
//     // TODO: implement toString
//     return super.toString();
//   }
// }


