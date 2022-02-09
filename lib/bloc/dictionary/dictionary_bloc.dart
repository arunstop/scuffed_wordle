import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:scuffed_wordle/ui.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepo dictionaryRepo;

  DictionaryBloc({required this.dictionaryRepo})
      : super(DictionaryDefault(dictionary: DictionaryEmpty())) {
    // Initialize state
    on<DictionaryInitialize>((event, emit) async {
      Dictionary localDictionary = await dictionaryRepo.getLocalDictionary();

      // If there is no local dictionary
      if (localDictionary is DictionaryEmpty) {
        Dictionary dictionary = await dictionaryRepo.getDictionary(length: 5);
        // Apply changes
        emit(state.copyWith(dictionary: dictionary));
        // Save answer locally
        dictionaryRepo.setLocalDictionary(dictionary: dictionary);
        // print('new ${dictionary.answer}');
      }
      // If there is local answer, set it to the state.
      else {
        emit(state.copyWith(dictionary: localDictionary));
        // print('local ${localDictionary.answer}');
      }

      // print(await dictionaryRepo.getLocalAnswer());
    });

    on<DictionaryRefreshKeyword>((event, emit) async {
      // Get answers by randomizing the list
      String getAnswer(String currentAnswer) {
        List<String> answerList = state.dictionary.answerList;
        String newAnswer = answerList[Random().nextInt(answerList.length)];
        if (currentAnswer == newAnswer) {
          return getAnswer(newAnswer);
        } else {
          return newAnswer;
        }
      }
      // Apply changes to bloc
      emit(
        state.copyWith(
          dictionary: state.dictionary.copyWith(
            answer: getAnswer(state.dictionary.answer),
          ),
        ),
      );
      // Save answer locally
      dictionaryRepo.setLocalDictionary(dictionary: state.dictionary);
    });
  }
}
