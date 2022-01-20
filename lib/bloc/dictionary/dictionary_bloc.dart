import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/ui.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  DictionaryBloc() : super(const DictionaryInit()) {
    // Initialize state
    on<DictionaryInitialize>((event, emit) {
      // print('vwinit');

      var randomWord = event.list[Random().nextInt(event.list.length)];
      emit(state.copyWith(list: event.list, keyword: randomWord));
      // print(state.list);
    });

    on<DictionaryRefreshKeyword>((event, emit) {
      // print(state.keyword);
      var randomWord = state.list[Random().nextInt(state.list.length)];
      emit(state.copyWith(keyword: randomWord));
      // print(state.keyword);


    });
  }
}
