import 'dart:developer';
import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'package:scuffed_wordle/bloc/board/event.dart';
part 'package:scuffed_wordle/bloc/board/state.dart';

class BoardBloc extends Bloc<BoardEvent, BoardState> {
  BoardBloc() : super(BoardInit(word: const [])) {
    on<BoardAdd>((event, emit) {
      // print(event.letter);
      // String word = '${state.word} ${event.letter}';
      // List<String> result = state.word;
      // result.add(event.letter);
      List<String> word = [...state.word,event.letter];
      if(word.length >= 6){
        word = [event.letter];
      }
      emit(state.copywith(
        word:word,
      ));
    }
    );
    // on<BoardRemove>((event, emit) {
    //   emit(state.copywith(
    //     word: event.letter
    //   ));
    // }
    // );
  }
}