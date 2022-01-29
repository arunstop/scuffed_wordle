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
      String localAnswer = await dictionaryRepo.getLocalAnswer();
      
      String newAnswer;
      // Get random keyword to be a new answer 
      // If there is no local answer
      if (localAnswer.isEmpty) {
        newAnswer = keywordList[Random().nextInt(keywordList.length)];
      }
      // If there is local answer, set it to the state.
      else {
        newAnswer = localAnswer;
      }
      // Apply changes
      emit(DictionaryState(list: validWordList, keyword: newAnswer));
      // Save answer locally
      dictionaryRepo.setLocalAnswer(answer: state.keyword);
      // print(await dictionaryRepo.getLocalAnswer());
    });

    on<DictionaryRefreshKeyword>((event, emit) async {
      // Get list of possible answers
      var keywordList = await dictionaryRepo.getKeywordList();
      // Get answers by randomizing the list
      var randomKeyword = keywordList[Random().nextInt(keywordList.length)];
      // Apply changes to bloc
      emit(state.copyWith(keyword: randomKeyword));
      // Save answer locally
      dictionaryRepo.setLocalAnswer(answer: state.keyword);
    });
  }
}
