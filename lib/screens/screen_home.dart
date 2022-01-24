import 'dart:math';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/widget_keyboard.dart';
import 'package:scuffed_wordle/widgets/widget_board.dart';
import 'package:scuffed_wordle/widgets/widget_result_dialog.dart';
import 'package:scuffed_wordle/widgets/widget_screen_template.dart';

class PageHome extends StatelessWidget {
  const PageHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    var boardBloc = context.watch<BoardBloc>();
    var dictionaryBloc = context.watch<DictionaryBloc>();
    // late var state123 = bloc.state;
    // print('build');
    // BoardBloc bloc(BuildContext ctx) {
    //   return ctx.read<BoardBloc>();
    // }

    void _onKeyboardPressed(BuildContext ctx, RawKeyEvent event) {
      if (event is RawKeyDownEvent) {
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

    void _blocListener(BuildContext listenerCtx, BoardState listenerState) {
      // Finish the game if attempt has reached its limit
      if (listenerState is BoardSubmitted) {
        // UiController.showSnackbar(
        //   context: context,
        //   message: "Submitted",
        //   actionLabel: 'OK',
        // );
        UiController.showConfirmationDialog(
          context: listenerCtx,
          title: 'Game over',
          content: const DialogResult(),
          actionN: () => {},
          actionY: () async {
            var state = boardBloc.state;
            
            // Turn the submitted boad into string format
            var resultClipBoard = state.submittedWordList.map((word) {
              return word.mapIndexed((letterIndex, letter) {
                String lineBreak = letterIndex + 1 == word.length ? "\n" : "";
                if (letter.color == BoardColors.base) {
                  // Black
                  return "⬛$lineBreak";
                } else if (letter.color == BoardColors.okLetter) {
                  // Yellow
                  return "🟨$lineBreak";
                } else if (letter.color == BoardColors.pinpoint) {
                  // Green
                  return "🟩$lineBreak";
                }
              }).join();
            }).join();
            var totalAttempt = state.attempt>state.attemptLimit ? 'X' : state.attempt;
            var text =
                "SCUFFED WORDLE ${totalAttempt}/${state.attemptLimit}\n\n${resultClipBoard}";
            Clipboard.setData(ClipboardData(text: text));
            UiController.showSnackbar(
              context: context,
              message: 'Copied to clipboard',
            );
            // Restart game
            boardBloc.add(BoardRestart());

            var keywordList = await Dictionary.getKeywordList(context);
            var randomKeyword =
                keywordList[Random().nextInt(keywordList.length)];

            dictionaryBloc.add(DictionaryRefreshKeyword(
                  keyword: randomKeyword,
                ));

            // dictionaryBloc.add(DictionaryRefreshKeyword());
          },
        );
      }
    }

    return ScreenTemplate(
      title: title,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          icon: const Icon(Icons.settings),
        ),
      ],
      child: BlocListener<BoardBloc, BoardState>(
        listener: _blocListener,
        child: RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (event) {
            // Keep typing if attempt is below its limit
            if (boardBloc.state is! BoardSubmitted) {
              _onKeyboardPressed(context, event);
            }
          },
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('${dictionaryBloc.state.keyword}'),
                // // Text('${state.word}'),
                // if (bloc.state is BoardSubmitted)
                // IconButton(
                //   onPressed: () =>
                //       //     dictionaryBloc.add(DictionaryInit(list: [
                //       //   "wrist",
                //       //   "write",
                //       //   "wrong",
                //       //   "yield",
                //       //   "young",
                //       //   "yours",
                //       //   "youth",
                //       // ],)),
                //       dictionaryBloc.add(DictionaryRefreshKeyword()),
                //   icon: const Icon(Icons.refresh_outlined),
                // ),
                // IconButton(
                //   onPressed: () =>
                //       // dictionaryBloc.add(DictionaryRefreshKeyword()),
                //       boardBloc.add(BoardTest()),
                //   icon: const Icon(Icons.adb),
                // ),
                // Text('${bloc.state.attempt}'),
                Board(rows: 6, cols: 5),
                Container(
                  alignment: Alignment.bottomCenter,
                  // color: Theme.of(context).colorScheme.secondary,
                  child:const Keyboard(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
