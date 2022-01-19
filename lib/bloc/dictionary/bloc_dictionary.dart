import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/event_dictionary.dart';
import 'package:scuffed_wordle/bloc/dictionary/state_dictionary.dart';
import 'package:scuffed_wordle/ui.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  DictionaryBloc() : super(const DictionaryState()) {
    on<DictionaryInit>((event, emit) async {
      // print('vwinit');

      var randomWord = event.list[Random().nextInt(703)];
      emit(
        state.copyWith(
          list: event.list,
          status: state.status,
          keyword: randomWord
        )
      );
      // print(state.list);
    });
  }
}
