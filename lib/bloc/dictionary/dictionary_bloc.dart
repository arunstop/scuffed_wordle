import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/data/models/model_dictionary.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:scuffed_wordle/ui.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepo dictionaryRepo;

  DictionaryBloc({required this.dictionaryRepo})
      : super(const DictionaryDefault()) {
    // Initialize state
    on<DictionaryInitialize>((event, emit) async {
      Dictionary dictionary = await dictionaryRepo.getDictionary(length: 5);
      String localAnswer = await dictionaryRepo.getLocalAnswer();
      
      String newAnswer;
      // Get random keyword to be a new answer 
      // If there is no local answer
      if (localAnswer.isEmpty) {
        newAnswer = dictionary.answer;
        print('new $newAnswer');
      }
      // If there is local answer, set it to the state.
      else {
        newAnswer = localAnswer;
        print('local $newAnswer');
      }
      // Apply changes
      emit(DictionaryState(list: dictionary.words, keyword: newAnswer));
      // Save answer locally
      dictionaryRepo.setLocalAnswer(answer: state.keyword);
      // print(await dictionaryRepo.getLocalAnswer());
    });

    on<DictionaryRefreshKeyword>((event, emit) async {
      // Get answers by randomizing the list
      String getAnswer(String currentAnswer){
        String newAnswer = state.list[Random().nextInt(state.list.length)];
        if(currentAnswer==newAnswer){
          return getAnswer(newAnswer);
        }else{
          return newAnswer;
        }
      };
      var randomKeyword = getAnswer(state.keyword);
      // Apply changes to bloc
      emit(state.copyWith(keyword: randomKeyword));
      // Save answer locally
      dictionaryRepo.setLocalAnswer(answer: state.keyword);
    });
  }
}
