import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/ui/ui_bloc.dart';
import 'package:scuffed_wordle/bloc/ui/ui_events.dart';
import 'package:scuffed_wordle/bloc/ui/ui_states.dart';
import 'package:scuffed_wordle/data/stt.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MicInput extends StatefulWidget {
  final int guessLength;
  final void Function(bool value, bool isError) toggleVoiceInput;
  final void Function(String word) detectedWords;
  const MicInput({
    Key? key,
    required this.guessLength,
    required this.toggleVoiceInput,
    required this.detectedWords,
  }) : super(key: key);

  @override
  State<MicInput> createState() => _MicInputState();
}

class _MicInputState extends State<MicInput> {
  final SpeechToText _speechToText = SpeechToText();
  
  late BoardBloc boardBloc;

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await _speechToText.stop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    boardBloc = context.read<BoardBloc>();
    // _detectedWord = _listeningLabel;
    // print('12312');
    _initSpeechToText();
  }

  void _initSpeechToText() async {
    // check if the widget is mounted
    if (mounted == false) {
      return;
    }
    // _speechEnabled = await _speechToText.initialize(
    //   onStatus: (status) {
    //     print("status ${status}");
    //     if(status!="listening" && !_isError){
    //       _stopListening();
    //     }
    //   },
    //   // Check if microphone is blocked
    //   onError: (errorNotification) {
    //     print("error ${errorNotification}");
    //     String msg = errorNotification.errorMsg;
    //     if (_isListening && msg == "not-allowed") {
    //       setState(() {
    //         _isError = true;
    //         _detectedWord = _micDisabled;
    //       });
    //       widget.toggleVoiceInput(true, _isError);
    //     }
    //     // else if (_isListening && msg == "no-speech") {
    //     //   setState(() {
    //     //     _isError = false;
    //     //     // _detectedWord = _micDisabled;
    //     //   });
    //     //   _stopListening();
    //     // } else {
    //     //   setState(() {
    //     //     _isError = false;
    //     //     // _detectedWord = _micDisabled;
    //     //   });
    //     //   _stopListening();
    //     // }
    //   },
    // );
    print(_speechToText.isAvailable);
    // print(await _speechToText);
    // setState(() {});
  }

  void _startListening() async {
    // if (await _speechToText.hasError && _isError) {
    //   print('error');
    //   setState(() {
    //     _isError = true;
    //     _detectedWord = "Microphone has been blocked.";
    //   });
    //   // return;
    // }else{
    //   setState(() {
    //     _isError = false;
    //     _detectedWord = _listeningLabel;
    //   });
    // }
    // print(await _speechToText.lastError);
    // if (mounted == false && _isError) {
    //   return;
    // }
    // setState(() {
    //   _isListening = true;
    //   widget.toggleVoiceInput(true, false);
    // });
    // var locale = await _speechToText.locales();
    // // print();
    // if ((locale).isNotEmpty) {
    //   print(locale[0].localeId);
    // }
    UiBloc uiBloc = context.read<UiBloc>();
    uiBloc.add(UiSttToggleInput());
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: Duration(seconds: 30),
      // pauseFor: Duration(seconds: 5),
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      localeId: "en-US",
    );
  }

  void _stopListening() async {
    UiBloc uiBloc = context.read<UiBloc>();
    uiBloc.add(UiSttToggleInput());
    if (mounted == false) {
      return;
    }
    // turn off listening, error indicator for ui purposes
    // setState(() {
    //   _isListening = false;
    //   widget.toggleVoiceInput(false, false);

    //   _detectedWord = _listeningLabel;
    //   _isError = false;
    // });
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    // check if stt still listening and widget is mounted
    // if (mounted == false || _isListening == false) {
    //   return;
    // }

    // String lastDetectedWord =
    //     result.alternates.last.recognizedWords.toUpperCase().trim();
    // if (_detectedWord == lastDetectedWord &&
    //     lastDetectedWord.isNotEmpty &&
    //     lastDetectedWord.contains(" ")) {
    //   return;
    // }
    // // print(_detectedWord);
    // setState(() {
    //   _detectedWord = lastDetectedWord;
    // });

    // widget.detectedWords(lastDetectedWord);
    // // DictionaryBloc dictionaryBloc = context.read<DictionaryBloc>();
    // context.read<BoardBloc>().add(
    //       BoardAddGuess(
    //         guess: _detectedWord,
    //         length: widget.guessLength,
    //       ),
    //     );
  }

  void _submitGuess() {
    DictionaryBloc dictionaryBloc = context.read<DictionaryBloc>();
    SettingsBloc settingsBloc = context.read<SettingsBloc>();

    boardBloc.add(
      BoardSubmitGuess(
        settings: settingsBloc.state.settings,
        wordList: dictionaryBloc.state.dictionary.wordList,
        answer: dictionaryBloc.state.dictionary.answer,
      ),
    );
    // setState(() {
    //   _detectedWord = _listeningLabel;
    // });
    _stopListening();
  }

  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = context.watch<UiBloc>();
    Stt uiStt = uiBloc.state.stt;
    bool isShowingInput = uiStt.isShowingInput;
    bool isListening = uiStt.status ==  SttStatus.listening;
    bool isError = uiStt.isError;
    BorderRadius borderRadius = const BorderRadius.horizontal(
      left: Radius.circular(60),
      right: Radius.circular(0),
    );

    Color getBarColor() {
      // Check if listening
      if (isShowingInput) {
        // Check if stt is error
        if (isError == true) {
          return ColorLib.error;
        } else {
          return Theme.of(context).colorScheme.primary;
        }
      }
      return ColorLib.tileBase;
    }

    Widget leftRoundedButton({
      required Color color,
      required Icon icon,
      required VoidCallback action,
    }) {
      return Container(
        height: 48,
        width: 60,
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          elevation: 0,
          color: color,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: action,
            child: Center(
              child: icon,
            ),
          ),
        ),
      );
    }

    Widget getIndicator() {
      return Row(
        children: [
          if (isListening)
            SpinKitDoubleBounce(
              color: Colors.white,
              size: 42,
              // type: SpinKitWaveType.center,
              duration: Duration(milliseconds: 1800),
            )
          else if (isError)
            Icon(
              Icons.error_outline,
              size: 36,
              color: Colors.white,
            )
          else
            Container(),
          // give space is not error
          isShowingInput ? UiLib.hSpace(12) :Container() ,
          Flexible(
            child: Text(
              uiStt.indicatorTxt,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      color: getBarColor(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: getIndicator(),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: ColorLib.gameAlt,
            ),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                  child: isShowingInput
                      ? leftRoundedButton(
                          color: ColorLib.gameAlt,
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          action: () {
                            _stopListening();
                          },
                        )
                      : Container(
                          key: ValueKey<String>('mic-input-close-button'),
                        ),
                ),
                // hide submit button if error
                isError
                    ? Container()
                    : leftRoundedButton(
                        color: isShowingInput
                            ? ColorLib.gameMain
                            : Theme.of(context).colorScheme.primary,
                        icon: Icon(
                          isShowingInput ? Icons.check : Icons.mic_rounded,
                          color: Colors.white,
                        ),
                        action: () {
                          if (_speechToText.isNotListening) {
                            _startListening();
                          } else {
                            _submitGuess();
                          }
                        },
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
