import 'dart:convert';

import 'package:flutter/foundation.dart';

enum SttStatus{
  listening,notListening,done,error
}

class Stt {
  bool isShowingInput;
  SttStatus status;
  bool isError;
  String indicatorTxt;
  String placeholderTxt;
  // String lastDetectedWord;
  List<String> detectedWordList;

  Stt({
    this.isShowingInput = false,
    this.status = SttStatus.notListening,
    this.isError=false,
    this.indicatorTxt = 'Play with your voice',
    this.placeholderTxt = '',
    // this.lastDetectedWord ='',
    this.detectedWordList =const [],
  });

  Stt copyWith({
    bool? isShowingInput,
    SttStatus? status,
    bool? isError,
    String? indicatorTxt,
    String? placeholderTxt,
    // String? lastDetectedWord,
    List<String>? detectedWordList,
  }) {
    return Stt(
      isShowingInput: isShowingInput ?? this.isShowingInput,
      status: status ?? this.status,
      isError: isError ?? this.isError,
      indicatorTxt: indicatorTxt ?? this.indicatorTxt,
      placeholderTxt: placeholderTxt ?? this.placeholderTxt,
      // lastDetectedWord: lastDetectedWord ?? this.lastDetectedWord,
      detectedWordList: detectedWordList ?? this.detectedWordList,
    );
  }

  String get lastDetectedWord => detectedWordList.isEmpty ? '' : detectedWordList.last;

  @override
  String toString() {
    return 'Stt(isInputShowing: $isShowingInput, status: $status, isError: $isError, indicatorTxt: $indicatorTxt, placeholderTxt: $placeholderTxt, lastDetectedWord: $lastDetectedWord, detectedWordList: $detectedWordList)';
  }

}
