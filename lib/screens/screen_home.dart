import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/loading_indicator_widget.dart';
import 'package:scuffed_wordle/widgets/widget_keyboard.dart';
import 'package:scuffed_wordle/widgets/widget_board.dart';
import 'package:scuffed_wordle/widgets/widget_result_dialog.dart';
import 'package:scuffed_wordle/widgets/widget_screen_template.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserLocalData();
  }

  _loadUserLocalData() {
    // TODO: implement initState
    var dictionaryBloc = context.read<DictionaryBloc>();
    dictionaryBloc.add(DictionaryInitialize());

    context.read<SettingsBloc>().add(SettingsInitialize());

    // context.read<BoardBloc>().add(BoardInitialize());
  }

  @override
  Widget build(BuildContext context) {
    var boardBloc = context.watch<BoardBloc>();
    var dictionaryBloc = context.read<DictionaryBloc>();
    var settingsBloc = context.read<SettingsBloc>();
    Settings settings = settingsBloc.state.settings;

    void _onKeyboardPressed(BuildContext ctx, RawKeyEvent event) {
      BoardState boardState = boardBloc.state;
      if (event is RawKeyDownEvent) {
        final letter = event.logicalKey.keyLabel;
        bool backspaced = event.logicalKey == LogicalKeyboardKey.backspace;
        bool entered = event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter;
        // if guess is empty & backspace is pressed, do nothing
        if (boardState.word.isEmpty && backspaced) {
          return;
        }
        // if guess reached max required letter
        // and the key is not enter or backspace
        // do nothing
        else if (boardState.word.length == 5 && !backspaced && !entered) {
          return;
        }
        // LogicalKeyboardKey.backspace;
        if (UiController.keyboardKeys.contains(letter.toUpperCase())) {
          if (backspaced) {
            boardBloc.add(BoardRemoveLetter());
          } else if (entered) {
            boardBloc.add(BoardSubmitGuess());
          } else {
            boardBloc.add(BoardAddLetter(letter: letter));
          }
        }
      }
      // print(key.keyLabel);
    }

    void _showResultDialog(BuildContext ctx) {
      UiController.showConfirmationDialog(
          context: ctx,
          title: 'Game over',
          content: const DialogResult(),
          noAction: true);
    }

    void _boardBlocListener(
        BuildContext listenerCtx, BoardState listenerState) {
      // Finish the game if attempt has reached its limit
      // print(listenerState);
      if (listenerState is BoardGameOver) {
        // UiController.showSnackbar(
        //   context: context,
        //   message: "Submitted",
        //   actionLabel: 'OK',
        // );
        _showResultDialog(listenerCtx);
      }
    }

    return ScreenTemplate(
      title: widget.title,
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
        listener: _boardBlocListener,
        child: RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: boardBloc.state is BoardGameOver
              ? null
              : (event) => _onKeyboardPressed(context, event),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1234),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              alignment: Alignment.center,
              child: child,
            ),
            child: boardBloc.state is BoardDefault
                ? const LoadingIndicator()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text('${boardBloc.state.runtimeType}'),
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
