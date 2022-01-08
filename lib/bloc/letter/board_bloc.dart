import 'dart:developer';
import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'package:scuffed_wordle/bloc/letter/board_event.dart';
part 'package:scuffed_wordle/bloc/letter/board_state.dart';

class BoardBloc extends Bloc<BoardEvent, String> {
  BoardBloc() : super('') {
    on<BoardEvent>((event, emit) {
      // TODO: implement event handler
        // print(event);
      if(event is BoardAdd){
        
        print(event.letter);
        
        emit(state+event.letter);
      }else {
        // emit(state-1);
      }
    }
    );
  }
}