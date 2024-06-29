import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/models/word_definition/word_model.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:scuffed_wordle/data/repositories/settings_repository.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  DictionaryBloc({
    required this.dictionaryRepo,
    required this.settingsRepo,
  }) : super(DictionaryDefault(dictionary: DictionaryEmpty())) {
    // Initialize state
    on<DictionaryInitialize>(_onDictionaryInitialize);
    // Refresh keyword
    on<DictionaryRefreshKeyword>(_onDictionaryRefreshKeyword);
    // Define answer
    on<DictionaryDefine>(_onDictionaryDefine);

    // on<DictionaryTest>((event, emit) {
    //   EncryptingService xd = EncryptingService();
    //   String enc = xd.encrypt(state.dictionary.answer);
    //   // print(enc);
    //   // print(xd.decrypt(enc));
    //   print(state.dictionary.answer);
    // });
  }

  final DictionaryRepo dictionaryRepo;
  final SettingsRepo settingsRepo;

  FutureOr<void> _onDictionaryInitialize(
    DictionaryInitialize event,
    Emitter<DictionaryState> emit,
  ) async {
    // check if it is re-initialize
    // or initialize
    // by checking the type
    if (state is! DictionaryDefault) {
      emit(DictionaryDefault(dictionary: DictionaryEmpty()));
    }
    Dictionary localDictionary = await dictionaryRepo.getLocalDictionary();
    Settings settingsLocal = await settingsRepo.getLocalSettings();

    print('ld : ${localDictionary.letterCount}');
    print('ev : ${settingsLocal.guessLength}');
    // If there is no local dictionary
    if (localDictionary is DictionaryEmpty ||
        // Check if length is different/changed
        localDictionary.letterCount != settingsLocal.guessLength ||
        // Check if difficulty is different/changed
        localDictionary.difficulty.toLowerCase() !=
            settingsLocal.difficulty.toLowerCase()) {
      Dictionary dictionary = await dictionaryRepo.getDictionary(
        length: settingsLocal.guessLength,
        difficulty: settingsLocal.difficulty,
      );
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
    // print(state.dictionary.answer);
    // print(await dictionaryRepo.getLocalAnswer());
  }

  void _onDictionaryRefreshKeyword(
    DictionaryRefreshKeyword event,
    Emitter<DictionaryState> emit,
  ) {
    // Get answers by randomizing the list
    String getAnswer(String currentAnswer) {
      // remove current answer from answer list
      List<String> answerList = state.dictionary.answerList
          .where((element) => element != currentAnswer)
          .toList();
      return answerList[Random().nextInt(answerList.length)];
    }

    // Apply changes to bloc
    // print(state.dictionary.wordDefinition);
    emit(
      state.copyWith(
        dictionary: state.dictionary.copyWith(
          answer: getAnswer(state.dictionary.answer),
          // wordDefinition: null,
        ),
        status: DictionaryStateStatus.init,
      ),
    );
    // print(state.dictionary.wordDefinition);
    // Save answer locally
    dictionaryRepo.setLocalDictionary(dictionary: state.dictionary);
  }

  FutureOr<void> _onDictionaryDefine(
    DictionaryDefine event,
    Emitter<DictionaryState> emit,
  ) async {
    // Change status to loading
    emit(state.statusLoading());
    Word? wordDefinition = await dictionaryRepo.getWordDefinition(
      lang: 'en',
      word: state.dictionary.answer.toLowerCase(),
    );

    // If there is a definition
    // or it is not error
    if (wordDefinition != null) {
      // print("before: ${state.dictionary.wordDefinition?.phonetic}");
      emit(
        state.copyWith(
          dictionary: state.dictionary.copyWith(
            wordDefinition: wordDefinition,
          ),
          // done loading
          status: DictionaryStateStatus.ok,
        ),
      );

      dictionaryRepo.setLocalDictionary(dictionary: state.dictionary);

      // print("after: ${state.dictionary.wordDefinition?.phonetic}");
    }
    // If there is local answer, apply state and revert
    // the type into
    else {
      //done loading
      emit(state.statusError());
      print('none');
      // print('local ${localDictionary.answer}');
    }

    // print(await dictionaryRepo.getLocalAnswer());
  }
}
