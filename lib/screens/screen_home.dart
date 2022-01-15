import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/bloc.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/widget_keyboard.dart';
import 'package:scuffed_wordle/widgets/widget_board.dart';
import 'package:scuffed_wordle/widgets/widget_result_dialog.dart';

class PageHome extends StatelessWidget {
  const PageHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<BoardBloc>();
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
            bloc.add(BoardRemoveLetter());
          } else if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.numpadEnter) {
            bloc.add(BoardSubmitWord());
          } else {
            bloc.add(BoardAddLetter(letter: letter));
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
          content: DialogResult(),
          actionN: () => bloc.add(BoardRestart()),
          actionY: () {
            var state = bloc.state;
            var resultWordList = state.wordList.sublist(0, state.attempt);
            // Turn the submitted boad into string format
            var resultClipBoard = resultWordList.map((word) {
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
            Clipboard.setData(ClipboardData(text: resultClipBoard));
            UiController.showSnackbar(
              context: context,
              message: 'Copied to clipboard',
            );
            bloc.add(BoardRestart()); 
          },
        );
      }
    }

    void _doNavigate() {
      Navigator.pushNamed(context, '/settings');
    }

    return Center(
      child: SizedBox(
        width: 480,
        child: BlocListener<BoardBloc, BoardState>(
          listener: _blocListener,
          child: RawKeyboardListener(
            autofocus: true,
            focusNode: FocusNode(),
            onKey: (event) {
              // Keep typing if attempt is below its limit
              if (bloc.state is! BoardSubmitted) {
                _onKeyboardPressed(context, event);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                // Here we take the value from the PageHome object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(title),
                actions: [
                  IconButton(
                    onPressed: () => _doNavigate(),
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
              body: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text('${bloc.state.wordList}'),
                    // // Text('${state.word}'),
                    // if (bloc.state is BoardSubmitted)
                    //   IconButton(
                    //     onPressed: () => bloc.add(BoardRestart()),
                    //     icon: const Icon(Icons.refresh_outlined),
                    //   ),
                    // Text('${bloc.state.attempt}'),
                    Board(rows: 6, cols: 5),
                    Container(
                      alignment: Alignment.bottomCenter,
                      // color: Theme.of(context).colorScheme.secondary,
                      child: Keyboard(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
