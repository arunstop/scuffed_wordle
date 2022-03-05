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
  // final void Function(bool value, bool isError) toggleVoiceInput;
  // final void Function(String word) detectedWords;
  MicInput({
    Key? key,
    required this.guessLength,
    // required this.toggleVoiceInput,
    // required this.detectedWords,
  }) : super(key: key);

  @override
  State<MicInput> createState() => _MicInputState();
}

class _MicInputState extends State<MicInput> {
  final SpeechToText _speechToText = SpeechToText();
  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    // await _speechToText.stop();
      await _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = context.watch<UiBloc>();
    BoardBloc boardBloc = context.watch<BoardBloc>();
    Stt uiStt = uiBloc.state.stt;
    bool isShowingInput = uiStt.isShowingInput;
    bool isListening = uiStt.status == SttStatus.listening;
    bool isError = uiStt.isError;
    BorderRadius borderRadius = const BorderRadius.horizontal(
      left: Radius.circular(60),
      right: Radius.circular(0),
    );

    void _onSpeechResult(SpeechRecognitionResult result) {
      // check if stt still listening and widget is mounted
      if (uiBloc.state.stt.status != SttStatus.listening) return;

      // check if the word is empty/not valid
      String lastDetectedWord =
          result.alternates.last.recognizedWords.toUpperCase().trim();
      if (uiStt.lastDetectedWord == lastDetectedWord &&
          lastDetectedWord.isEmpty) {
        return;
      }
      // update the word on speech to text ui
      uiBloc.add(UiSttAddWords(words: lastDetectedWord));
      // add guess
      context.read<BoardBloc>().add(
            BoardAddGuess(
              guess: uiBloc.state.stt.lastDetectedWord,
              length: widget.guessLength,
            ),
          );
    }

    void _startListening() async {
      UiBloc uiBloc = context.read<UiBloc>();
      uiBloc.add(UiSttToggleInput());
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: Duration(seconds: 30),
        // countdown to stop listening when the user is not speaking anymore when listening
        pauseFor: Duration(seconds: 12),
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
        localeId: "en-US",
      );
    }

    void _stopListening() async {
      UiBloc uiBloc = context.read<UiBloc>();
      uiBloc.add(UiSttToggleInput());
      // if (mounted == false) {
      //   return;
      // }
      // turn off listening, error indicator for ui purposes
      // setState(() {
      //   _isListening = false;
      //   widget.toggleVoiceInput(false, false);

      //   _detectedWord = _listeningLabel;
      //   _isError = false;
      // });
      await _speechToText.stop();
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
      // stop listening after adding guess
      _stopListening();
    }

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
          if (isListening && !isError)
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
          isShowingInput ? UiLib.hSpace(12) : Container(),
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
