import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/models/status_model.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/loading_indicator_widget.dart';
import 'package:scuffed_wordle/widgets/widget_keyboard.dart';
import 'package:scuffed_wordle/widgets/widget_board.dart';
import 'package:scuffed_wordle/widgets/widget_result_dialog.dart';
import 'package:scuffed_wordle/widgets/widget_screen_template.dart';
import 'package:animations/animations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    // print('s-home');
    BoardBloc boardBloc = context.watch<BoardBloc>();
    DictionaryBloc dictionaryBloc = context.watch<DictionaryBloc>();
    SettingsBloc settingsBloc = context.read<SettingsBloc>();
    Settings settings = settingsBloc.state.settings;

    void _onKeyboardPressed(BuildContext ctx, RawKeyEvent event) {
      BoardState boardState = boardBloc.state;
      if (event is RawKeyDownEvent) {
        final letter = event.logicalKey.keyLabel;
        bool backspaced = event.logicalKey == LogicalKeyboardKey.backspace;
        bool entered = event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter;
        // if guess is empty & backspace is pressed, do nothing
        // print('${settings.guessLength}');
        if (boardState.word.isEmpty && backspaced) {
          return;
        }
        // if guess reached max required letter
        // and the key is not enter or backspace
        // do nothing
        else if (boardState.word.length == settings.guessLength &&
            !backspaced &&
            !entered) {
          return;
        }
        // LogicalKeyboardKey.backspace;
        if (UiLib.keyboardKeys.contains(letter.toUpperCase())) {
          if (backspaced) {
            boardBloc.add(BoardRemoveLetter());
          } else if (entered) {
            Dictionary dictionary = dictionaryBloc.state.dictionary;
            boardBloc.add(BoardSubmitGuess(
                settings: settings,
                answer: dictionary.answer,
                wordList: dictionary.wordList));
          } else {
            boardBloc.add(BoardAddLetter(letter: letter));
          }
        }
      }
      // print(key.keyLabel);
    }

    void _showResultDialog(BuildContext ctx) {
      Dictionary dictionary = dictionaryBloc.state.dictionary;
      // get definition
      // dictionaryBloc.add(
      //   DictionaryDefine(
      //     lang: 'en',
      //     word: dictionaryBloc.state.dictionary.answer,
      //   ),
      // );
      UiLib.showBottomSheet(
        context: ctx,
        content: DialogResult(
          answer: dictionary.answer,
          tts: FlutterTts()
            ..awaitSpeakCompletion(true)
            ..setLanguage('en-GB')
            ..setVolume(1.0)
            ..setPitch(1.0)
            ..setSpeechRate(0.4),
          // definition: dictionary.wordDefinition,
        ),
      );
    }

    void _boardBlocListener(
        BuildContext listenerCtx, BoardState listenerState) {
      // Finish the game if attempt has reached its limit
      // print();
      if (listenerState is BoardGameOver) {
        // UiLib.showSnackbar(
        //   context: context,
        //   message: "Submitted",
        //   actionLabel: 'OK',
        // );
        // Dictionary dictionary = dictionaryBloc.state.dictionary;
        // bool isDefinitionValid = dictionary.wordDefinition != null &&
        //     dictionary.answer == dictionary.wordDefinition?.word;
        // if (!isDefinitionValid) {
        //   dictionaryBloc.add(
        //     DictionaryDefine(
        //       lang: 'en',
        //       word: dictionaryBloc.state.dictionary.answer,
        //     ),
        //   );
        // }
        // print('resd');
        _showResultDialog(context);
      }
    }

    return ScreenTemplate(
      title: title,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/howtoplay'),
          icon: const Icon(Icons.help_outline_rounded),
        ),
        IconButton(
          onPressed: () => boardBloc.state is BoardGameOver
              ? _showResultDialog(context)
              : null,
          icon: const Icon(Icons.bar_chart_rounded),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: const Icon(Icons.settings),
        ),
      ],
      child: BlocListener<BoardBloc, BoardState>(
        listenWhen: (previous, current) {
          // print(previous.runtimeType);
          // print(current.runtimeType);
          return previous.runtimeType != current.runtimeType;
        },
        listener: _boardBlocListener,
        child: RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: boardBloc.state is BoardGameOver
              ? null
              : (event) => _onKeyboardPressed(context, event),
          child: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            ),
            child: boardBloc.state is BoardDefault ||
                    dictionaryBloc.state is DictionaryDefault
                ? const LoadingIndicator()
                : SingleChildScrollView(
                    key: ValueKey<String>(
                        dictionaryBloc.state.dictionary.answer),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text('${boardBloc.state.runtimeType}'),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     dictionaryBloc.add(
                        //       DictionaryDefine(
                        //         lang: 'en',
                        //         word: dictionaryBloc.state.dictionary.answer,
                        //       ),
                        //     );
                        //     // boardBloc.add(BoardRestart());
                        //   },
                        //   child:
                        //       Text('${dictionaryBloc.state.dictionary.answer}'),
                        // ),
                        // Text('${dictionaryBloc.state.dictionary.answer}'),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       UiLib.showToast(status: Status.ok, text: 'XXXXXX is not in word list');
                        //     },
                        //     child: Text('Toast')),
                        const Board(),
                        settings.useMobileKeyboard
                            ? Container(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 45,
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      // padding: EdgeInsets.all(8)
                                    ),
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.keyboard_alt_outlined),
                                    label: const Text('Toggle Keyboard'),
                                  ),
                                ),
                              )
                            : Container(
                                alignment: Alignment.bottomCenter,
                                // color: Theme.of(context).colorScheme.secondary,
                                child: const Keyboard(),
                              )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
