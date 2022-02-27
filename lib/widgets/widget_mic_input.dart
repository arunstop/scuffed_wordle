import 'package:flutter/material.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MicInput extends StatefulWidget {
  const MicInput({Key? key}) : super(key: key);

  @override
  State<MicInput> createState() => _MicInputState();
}

class _MicInputState extends State<MicInput> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _listeningLabel = 'Listening...';
  String _detectedWord = '';
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
    _detectedWord = _listeningLabel;
    // print('12312');
    _initSpeechToText();
  }

  void _initSpeechToText() async {
    // check if the widget is mounted
    if (mounted == false) {
      return;
    }
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    if (mounted == false) {
      return;
    }
    setState(() {
      _isListening = true;
    });
    await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _stopListening() async {
    if (mounted == false) {
      return;
    }
    setState(() {
      _isListening = false;
      _detectedWord = _listeningLabel;
    });
    await _speechToText.stop();
  }

  void _submitGuess() {
    _stopListening();
    DictionaryBloc dictionaryBloc = context.read<DictionaryBloc>();
    SettingsBloc settingsBloc = context.read<SettingsBloc>();

    boardBloc.add(
      BoardSubmitGuess(
        settings: settingsBloc.state.settings,
        wordList: dictionaryBloc.state.dictionary.wordList,
        answer: dictionaryBloc.state.dictionary.answer,
      ),
    );
    setState(() {
      _detectedWord = _listeningLabel;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    // print('${boardBloc.state.attempt}');
    // print('${_isListening} ${result.recognizedWords}');
    if (mounted == false || _isListening == false) {
      return;
    }
    String lastDetectedWord =
        result.alternates.last.recognizedWords.toUpperCase().trim();
    if (_detectedWord == lastDetectedWord && lastDetectedWord.isNotEmpty) {
      return;
    }
    DictionaryBloc dictionaryBloc = context.read<DictionaryBloc>();
    // print(_detectedWord);
    setState(() {
      _detectedWord = lastDetectedWord;
    });
    context.read<BoardBloc>().add(
          BoardAddGuess(
            guess: _detectedWord,
            length: dictionaryBloc.state.dictionary.letterCount,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = const BorderRadius.horizontal(
      left: Radius.circular(60),
      right: Radius.circular(0),
    );

    Widget leftRoundedButton(
            {required Color color,
            required Icon icon,
            required VoidCallback action}) =>
        Container(
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

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      color: _isListening
          ? Theme.of(context).colorScheme.primary
          : ColorLib.tileBase,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              _isListening ? _detectedWord : 'Press the mic button',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                  ),
            ),
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
                  child: _isListening
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
                leftRoundedButton(
                  color: ColorLib.gameMain,
                  icon: Icon(
                    _isListening ? Icons.check : Icons.mic_rounded,
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
