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
import 'package:scuffed_wordle/ui.dart';
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

    void _onKeyboardPressed(BuildContext ctx, RawKeyEvent event) {
      if (event is RawKeyDownEvent && boardBloc.state is! BoardGameOver) {
        final letter = event.logicalKey.keyLabel;
        // LogicalKeyboardKey.backspace;
        if (UiController.keyboardKeys.contains(letter.toUpperCase())) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            boardBloc.add(BoardRemoveLetter());
          } else if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.numpadEnter) {
            boardBloc.add(BoardSubmitWord());
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
        noAction: true
      );
    }

    void _boardBlocListener(BuildContext listenerCtx, BoardState listenerState) {
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
          onKey: (event) {
            // Keep typing if attempt is below its limit
            if (boardBloc.state is! BoardGameOver) {
              _onKeyboardPressed(context, event);
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Board(),
                Container(
                  alignment: Alignment.bottomCenter,
                  // color: Theme.of(context).colorScheme.secondary,
                  child: const Keyboard(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
