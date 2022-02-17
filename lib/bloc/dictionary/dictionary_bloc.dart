import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/data/models/word_definition/word_model.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:scuffed_wordle/data/services/encrypting_service.dart';
import 'package:scuffed_wordle/ui.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final DictionaryRepo dictionaryRepo;

  DictionaryBloc({required this.dictionaryRepo})
      : super(DictionaryDefault(dictionary: DictionaryEmpty())) {
    // Initialize state
    on<DictionaryInitialize>(_onDictionaryInitialize);

    on<DictionaryRefreshKeyword>(_onDictionaryRefreshKeyword);
    on<DictionaryDefine>(_onDictionaryDefine);

    // on<DictionaryTest>((event, emit) {
    //   EncryptingService xd = EncryptingService();
    //   String enc = xd.encrypt(state.dictionary.answer);
    //   // print(enc);
    //   // print(xd.decrypt(enc));
    //   print(state.dictionary.answer);
    // });
  }

  FutureOr<void> _onDictionaryInitialize(
      DictionaryInitialize event, Emitter<DictionaryState> emit) async {
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
  }

  FutureOr<void> _onDictionaryRefreshKeyword(
      DictionaryRefreshKeyword event, Emitter<DictionaryState> emit) async {
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
    print(state.dictionary.wordDefinition);
    emit(
      state.copyWith(
        dictionary: state.dictionary.copyWith(
          answer: getAnswer(state.dictionary.answer),
          wordDefinition: null,
        ),
      ),
    );
    print(state.dictionary.wordDefinition);
    // Save answer locally
    dictionaryRepo.setLocalDictionary(dictionary: state.dictionary);
  }

  FutureOr<void> _onDictionaryDefine(
    DictionaryDefine event,
    Emitter<DictionaryState> emit,
  ) async {
    Word? wordDefinition = await dictionaryRepo.getWordDefinition(
      lang: event.lang,
      word: event.word.toLowerCase(),
    );

    // If there is a definition
    // or it is not error
    if (wordDefinition != null) {
      print(state.dictionary.wordDefinition?.phonetic);
      emit(
        state.copyWith(
          dictionary: state.dictionary.copyWith(
            wordDefinition: wordDefinition,
          ),
        ),
      );
      print(state.dictionary.wordDefinition?.phonetic);
    }
    // If there is local answer, set it to the state.
    else {
      print('none');
      // print('local ${localDictionary.answer}');
    }

    // print(await dictionaryRepo.getLocalAnswer());
  }
}
