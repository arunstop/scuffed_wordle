import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:scuffed_wordle/ui.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepo dictionaryRepo;

  DictionaryBloc({required this.dictionaryRepo})
      : super(const DictionaryDefault()) {
    // Initialize state
    on<DictionaryInitialize>((event, emit) async {
      // Get list of english word
      var validWordList = await dictionaryRepo.getValidWordList();
      // Get list of possible keyword
      var keywordList = await dictionaryRepo.getKeywordList();
      // Get random keyword
      var randomKeyword = keywordList[Random().nextInt(keywordList.length)];

      emit(DictionaryState(list: validWordList, keyword: randomKeyword));
    });

    on<DictionaryRefreshKeyword>((event, emit) async {
      var keywordList = await dictionaryRepo.getKeywordList();
      // Get random keyword
      var randomKeyword = keywordList[Random().nextInt(keywordList.length)];
      // print(state.keyword);
      // var randomWord = state.list[Random().nextInt(state.list.length)];
      emit(state.copyWith(keyword: randomKeyword));
      // print(state.keyword);
    });
  }
}
