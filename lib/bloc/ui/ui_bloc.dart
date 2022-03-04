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
    // on<UiSttStop>(onUiSttStop);
    // on<UiSttCancel>(onUiSttCancel);
  }

  void onUiSttInitialize(UiSttInitialize event, Emitter<UiState> emit) {}
  void onUiSttChangeStatus(UiSttChangeStatus event, Emitter<UiState> emit) {
    if (state.stt.isError) return;
    // print(event.status);
    // // emit(stt:);
    // SttStatus status = SttStatus.notListening;
    // String indicatorTxt = Stt().indicatorTxt;
    // String placeholderTxt = '';
    // if (event.status == 'listening') {
    //   status = SttStatus.listening;
    //   indicatorTxt = 'Listening...';
    //   placeholderTxt = 'Try to guess the answer\nwith your beautiful voice...';
    // } else {
    //   // if (state.stt.isError) {
    //   //   status = SttStatus.notListening;
    //   //   indicatorTxt = 'Access Denied!';
    //   //   placeholderTxt =
    //   //       'Microphone has been blocked.\nPlease enable the access to continue.';
    //   // } else {
    //   //   status = SttStatus.notListening;
    //   //   indicatorTxt = 'Play with your voice';
    //   // }
    // }

    // emit(state.copyWith(
    //   stt: state.stt.copyWith(
    //     isError: event.status=='listening' ? false : true,
    //     status: status,
    //     indicatorTxt: indicatorTxt,
    //     placeholderTxt: placeholderTxt,
    //   ),
    // ));
  }

  void onUiSttErrorOccurs(UiSttErrorOccurs event, Emitter<UiState> emit) {
    // enable error UI
    emit(
      UiInitial().copyWith(
        stt: state.stt.copyWith(
          isError: true,
          // status: SttStatus.error,
          indicatorTxt: 'Access Denied!',
          placeholderTxt: 'Microphone has been blocked.\nPlease enable the access to continue.'
        ),
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
}
