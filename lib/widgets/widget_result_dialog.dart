import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/models/word_definition/definition_model.dart';
import 'package:scuffed_wordle/data/models/word_definition/word_model.dart';
import 'package:scuffed_wordle/ui.dart';

class DialogResult extends StatefulWidget {
  final String answer;
  final FlutterTts tts;
  // final Word? definition;
  DialogResult({
    Key? key,
    required this.answer,
    required this.tts,
    // required this.definition,
  }) : super(key: key);

  @override
  State<DialogResult> createState() => _DialogResultState();
}

class _DialogResultState extends State<DialogResult> {
  TtsState ttsState = TtsState.stopped;
  @override
  void dispose() {
    // TODO: implement dispose
    widget.tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = context.read<BoardBloc>();
    DictionaryBloc dictionaryBloc = context.watch<DictionaryBloc>();
    SettingsBloc settingsBloc = context.read<SettingsBloc>();
    Word? definition = dictionaryBloc.state.dictionary.wordDefinition;

    // Close dialog
    void _close() => Navigator.pop(context);
    // Play again
    void _playAgain() async {
      _close();
      await Future.delayed(const Duration(milliseconds: 300));
      Settings settings = settingsBloc.state.settings;
      boardBloc.add(BoardRestart(
          // length: settings.guessLength,
          // lives: settings.lives,
          ));
      // boardBloc.add(
      //           BoardInitialize(
      //             length: 5,
      //             lives: 6,
      //           ),
      //         );
      dictionaryBloc.add(DictionaryRefreshKeyword());
      //   // dictionaryBloc.add(DictionaryDefine());
    }

    // Share result
    void _shareResult() {
      var state = boardBloc.state;
      // Turn the submitted boad into string format
      var resultClipBoard = state.submittedWordList.map((word) {
        return word.mapIndexed((letterIndex, letter) {
          String lineBreak = letterIndex + 1 == word.length ? "\n" : "";
          if (letter.color == ColorLib.tileBase) {
            // Black
            return "⬛$lineBreak";
          } else if (letter.color == ColorLib.tileOkLetter) {
            // Yellow
            return "🟨$lineBreak";
          } else if (letter.color == ColorLib.tilePinpoint) {
            // Green
            return "🟩$lineBreak";
          }
        }).join();
      }).join();
      bool gameOver = state.attempt > state.attemptLimit || !state.win;
      var totalAttempt = gameOver ? 'X' : state.attempt;
      var text =
          "SCUFFED WORDLE - ${settingsBloc.state.settings.matrix} : ${totalAttempt}/${state.attemptLimit}\n\n${resultClipBoard}";
      Clipboard.setData(ClipboardData(text: text));
      //
      UiLib.showSnackbar(
        context: context,
        message: 'Copied to clipboard',
      );
      _close();
    }

    void _defineWord(String answer) {
      print('defineword');
      // _close();
      dictionaryBloc.add(DictionaryDefine(
          // lang: 'en',
          // word: answer,
          ));
    }

    // Bordered button
    Widget _borderedButton({
      required String label,
      Icon? icon,
      required void Function()? action,
      bool noBorder = false,
    }) {
      return SizedBox(
        width: double.infinity,
        height: 45,
        child: OutlinedButton.icon(
          onPressed: action,
          icon: icon ?? const Text(''),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          // give no border coloring if noBorder is true
          style: noBorder
              ? null
              : ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
        ),
      );
    }

    Color _resultColor = boardBloc.state.win ? ColorLib.ok : ColorLib.error;
    bool _isDefinitionValid =
        definition != null && definition.word == widget.answer;
    List<Widget> _getDefinitionList(List<Definition> defList) {
      return defList
          .mapIndexed((index, def) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(child: Text('${def.definition}')),
                  ],
                ),
              ))
          .toList();
    }

    Future _speak(String text) async {
      setState(() => ttsState = TtsState.playing);
      await widget.tts.speak(text);
    }

    // change ttsstate when done
    widget.tts.setCompletionHandler(() {
      if (this.mounted) {
        setState(() {
          ttsState = TtsState.stopped;
        });
      }
    });
    // change tts state when playing
    widget.tts.setStartHandler(() {
      if (this.mounted) {
        setState(() {
          ttsState = TtsState.playing;
        });
      }
    });

    Widget _defineWordButton() {
      DictionaryStateStatus status = dictionaryBloc.state.status;
      if (status == DictionaryStateStatus.loading) {
        return SpinKitThreeInOut(
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        );
      } else if (status == DictionaryStateStatus.error) {
        return Chip(
          backgroundColor: ColorLib.error,
          label: Text(
            'Error: No definition found, sorry :(',
            style: Theme.of(context).textTheme.caption!.copyWith(
              color: Colors.white,
            ),
          ),
        );
      }
      return ElevatedButton.icon(
        onPressed: () => _defineWord(widget.answer),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        icon: const Icon(Icons.search),
        label: const Text('Define'),
      );
    }

    return Column(
      children: [
        // Header
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The answer was:',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                    // letterSpacing: 1,
                    // color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            UiLib.vSpace(60 / 10),
            // ANSWER
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.red,
                        border: Border.all(color: Colors.lightBlue)),
                    child: IconButton(
                      onPressed: ttsState == TtsState.playing
                          ? null
                          : () => _speak(widget.answer),
                      icon: ttsState == TtsState.playing
                          ? const SpinKitWave(
                              color: Colors.lightBlue,
                              size: 24,
                              type: SpinKitWaveType.center,
                              itemCount: 3,
                              // borderWidth: 12,
                              duration: Duration(milliseconds: 1200),
                            )
                          : const Icon(Icons.volume_up_rounded),
                      color: Colors.lightBlue,
                      iconSize: 30,
                    ),
                  ),
                  UiLib.hSpace(12),
                  Text(
                    '${widget.answer.toUpperCase()}',
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: _resultColor,
                        ),
                  ),
                  UiLib.hSpace(12),
                ],
              ),
            ),
          ],
        ),

        // Content
        // UiLib.vSpace(6),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            child: child,
          ),
          child: _isDefinitionValid == false
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: _defineWordButton(),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Phonetic
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: const Icon(Icons.volume_up_rounded),
                        //   color: Colors.lightBlue,
                        // ),
                        Flexible(
                          child: Text(
                            definition?.phonetic ?? widget.answer,
                            style: const TextStyle(
                              fontSize: 21,
                              letterSpacing: 2,
                              fontFamily: 'Rubik',
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Meanings
                    // UiLib.vSpace(6),
                    for (var meaning in definition!.meanings)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Center(
                              child: Text(
                                '-- ${meaning.partOfSpeech} --',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                  // fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w200,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          meaning.definitions!.isEmpty
                              ? const Text('')
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _getDefinitionList(
                                    meaning.definitions!,
                                  ),
                                )
                        ],
                      )
                  ],
                ),
        ),
        // Buttons
        Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: Column(
            children: [
              UiLib.vSpace(24),
              // Share Button
              _borderedButton(
                label: "Share Result",
                icon: const Icon(Icons.share_rounded),
                action: () => _shareResult(),
              ),
              UiLib.vSpace(9),
              // Play again button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: () => _playAgain(),
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Play Again",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              UiLib.vSpace(9),
              // Close button
              _borderedButton(
                label: "Close",
                icon: const Icon(Icons.close_rounded),
                action: () => _close(),
                noBorder: true,
              ),
              UiLib.vSpace(18),
            ],
          ),
        )
      ],
    );
  }
}

class BoardResult extends StatelessWidget {
  const BoardResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<BoardBloc>();
    var state = bloc.state;
    // Get submitted words
    // bloc.state.wordList.sublist(0,)
    // var submittedWordList = bloc.state.wordList.where((word) {
    //   var strWord = word.map((e) => e.letter).join();
    //   return strWord.isNotEmpty;
    // });

    // var submittedWordList = state.wordList.sublist(0, state.attempt);
    // print(submittedWordList);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 12,
        ),
        for (var word in state.submittedWordList)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var letter in word)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Card(
                    color: letter.color,
                  ),
                ),
            ],
          )
      ],
    );
  }
}
