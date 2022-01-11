import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/bloc.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widget/keyboard.dart';
import 'package:scuffed_wordle/widget/board.dart';

class PageHome extends StatelessWidget {
  const PageHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    print('build');

    void _onKeyboardPressed(BuildContext ctx, RawKeyEvent event) {
      if (event is RawKeyDownEvent) {
        final letter = event.logicalKey.keyLabel;
        // LogicalKeyboardKey.backspace;
        if (UiController.keyboardKeys.contains(letter.toUpperCase())) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            ctx.read<BoardBloc>().add(BoardRemoveLetter(letter: letter));
          } else if (event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.numpadEnter) {
            ctx.read<BoardBloc>().add(BoardSubmitWord());
          } else {
            ctx.read<BoardBloc>().add(BoardAddLetter(letter: letter));
          }
        }
      }
      // print(key.keyLabel);
    }

    void _doNavigate() {
      Navigator.pushNamed(context, '/settings');
    }

    return BlocProvider(
      create: (_) => BoardBloc(),
      child: BlocBuilder<BoardBloc, BoardState>(
        builder: (context, state) => RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (event) => _onKeyboardPressed(context, event),
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
            body: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text('${state.wordList}'),
                // Text('${state.word}'),
                // Text('${state.attempt}'),
                Board(rows: 6, cols: 5),
                Container(
                  alignment: Alignment.bottomCenter,
                  color: Theme.of(context).colorScheme.secondary,
                  // child: Keyboard(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
