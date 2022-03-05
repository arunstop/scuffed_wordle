import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/ui/ui_events.dart';
import 'package:scuffed_wordle/bloc/ui/ui_states.dart';
import 'package:scuffed_wordle/data/stt.dart';

class UiBloc extends Bloc<UiEvent, UiState> {
  UiBloc() : super(UiInitial()) {
    on<UiSttInitialize>(onUiSttInitialize);
    on<UiSttChangeStatus>(onUiSttChangeStatus);
    on<UiSttErrorOccurs>(onUiSttErrorOccurs);
    on<UiSttToggleInput>(onUiSttToggleInput);
    on<UiSttAddWords>(onUiSttAddWords);
    // on<UiSttStop>(onUiSttStop);
    // on<UiSttCancel>(onUiSttCancel);
  }

  void onUiSttInitialize(UiSttInitialize event, Emitter<UiState> emit) {}
  void onUiSttChangeStatus(UiSttChangeStatus event, Emitter<UiState> emit) {
    // do nothing if error
    if (state.stt.isError) return;
    // print(event.status);
    // emit(stt:);
    SttStatus status = SttStatus.notListening;
    String indicatorTxt = Stt().indicatorTxt;
    String placeholderTxt = '';
    // change some text when it is listening
    if (event.status == 'listening') {
      status = SttStatus.listening;
      indicatorTxt = 'Listening...';
      placeholderTxt = 'Try to guess the answer\nwith your beautiful voice...';
    } else {
      // if (state.stt.isError) {
      //   status = SttStatus.notListening;
      //   indicatorTxt = 'Access Denied!';
      //   placeholderTxt =
      //       'Microphone has been blocked.\nPlease enable the access to continue.';
      // } else {
      //   status = SttStatus.notListening;
      //   indicatorTxt = 'Play with your voice';
      // }
    }

    emit(state.copyWith(
      stt: state.stt.copyWith(
        // only show input when listening
        isShowingInput: status == SttStatus.listening ? true:false,
        status: status,
        indicatorTxt: indicatorTxt,
        placeholderTxt: placeholderTxt,
      ),
    ));
    // print(state.stt.detectedWordList);
  }

  void onUiSttErrorOccurs(UiSttErrorOccurs event, Emitter<UiState> emit) {
    // if(event.message=="no-speech")return;
    // enable error UI
    String indicatorTxt = 'Access Denied!';
    String placeholderTxt = 'Microphone has been blocked.\nPlease enable the access to continue.';
    // show a different text when no=speech is occured
    if(event.message=="no-speech"){
      indicatorTxt = 'No speech detected.';
      placeholderTxt = 'Unable to detect any words.\nEither no word is spoken or undetected errors occurred';
     }
    emit(
      UiInitial().copyWith(
        stt: state.stt.copyWith(
            isError: true,
            // status: SttStatus.error,
            indicatorTxt: indicatorTxt,
            placeholderTxt:
                placeholderTxt),
      ),
    );
  }

  void onUiSttToggleInput(UiSttToggleInput event, Emitter<UiState> emit) {
    // disable error ui while toggling the input ui
    emit(
      UiInitial().copyWith(
        stt: Stt(
          isError: false,
          isShowingInput: !state.stt.isShowingInput,
          // status: SttStatus.error,
        ),
      ),
    );
  }

  void onUiSttAddWords(UiSttAddWords event, Emitter<UiState> emit) {
    // disable error ui while toggling the input ui
    String words = event.words;
    List<String> wordList = state.stt.detectedWordList;

    // only add if the word is not in the list
    if (wordList.contains(words)) {
      // lastDetectedWord=words;
      // wordList.add(words);
      return;
    }

    // if (words.contains(' ')) {
    List<String> splitValue = words.split(' ');
    // Concat then distinct
    wordList = wordList.followedBy(splitValue).distinct().toList();
    // return;
    // } else {
    // lastDetectedWord = words;
    // }
    emit(
      state.copyWith(
        stt: state.stt.copyWith(
          // lastDetectedWord: lastDetectedWord,
          detectedWordList: wordList,
        ),
      ),
    );
    // print('state.ldw ${state.stt.lastDetectedWord}');
  }
}
