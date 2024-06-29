import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/data/constants.dart';
import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/utils/helpers.dart';
import 'package:scuffed_wordle/widgets/board/board_tile_widget.dart';

class Board extends StatelessWidget {
  const Board({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('build');
    // Dictionary.list(context).then((value) => print(value));
    var boardBloc = context.watch<BoardBloc>();
    var settingsBloc = context.watch<SettingsBloc>();
    // var dictionaryBloc = context.watch<DictionaryBloc>();
    var boardState = boardBloc.state;
    bool isPlaying = boardState is! BoardGameOver;

    String getLetter(int row, int col, String letter) {
      // Show the letter of the current answer if the based on attempt
      // when the board is not submitted
      if (boardState.attempt == row + 1 && isPlaying) {
        return boardState.word.length > col ? boardState.word[col] : '';
      }
      return letter;
    }

    Color? getColor(int row, Color? color) {
      // Change current attempt row's color
      // when the board is not submitted
      return boardState.attempt == row + 1 && isPlaying
          ? ColorLib.tileActiveRow
          : color;
    }

    Widget wTile(int row, int col, BoardLetter letter, bool guessed) {
      // Check if colorblind is on
      bool isColorBlind = settingsBloc.state.settings.colorBlindMode;
      bool isOnCurrentGuess = row + 1 == boardState.attempt && isPlaying;
      return BoardTile(
        key: ValueKey<String>(
            'tile-${row + 1}-${col + 1}-${guessed ? 'guessed' : 'empty'}'),
        isColorBlind: isColorBlind,
        letter: getLetter(row, col, letter.letter),
        // null safty
        color: getColor(row, letter.color)!,
        onStandBy: row + 1 > boardState.attempt,
        onType: isOnCurrentGuess && col == boardState.word.length,
        isWaitingToBeTyped: isOnCurrentGuess && col > boardState.word.length,
      );
    }

    List<Widget> wTileMatrix() {
      return boardBloc.state.wordList
          .mapIndexed(
            (row, word) => Row(
              key: ValueKey<String>('board-row-guessed-${row + 1}'),
              mainAxisAlignment: MainAxisAlignment.center,
              children: word.mapIndexed(
                (col, letter) {
                  bool guessed = Helpers.stringifyMatrixRow(word) != "";
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    reverseDuration: Duration(milliseconds: 300),
                    // switchInCurve: Curve.,
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      alignment: Alignment.center,
                      child: child,
                    ),
                    // Check if user attempt is the same as the row
                    child: wTile(row, col, letter, guessed),
                  );
                },
              ).toList(),
            ),
          )
          .toList();
    }

    return Flexible(
      child: Center(
        child: FittedBox(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Column(
              children: [
                // Text('${boardBloc.state.attempt}'),
                // TextButton(onPressed: ()=> dictionaryBloc.add(DictionaryTest()), child: Text('ENC/DEC')),
                // Row(children: [
                //   Text("${_start}"),
                //   TextButton(
                //     onPressed: () {},
                //     child: Text('Start'),
                //   )
                // ]),
                ...wTileMatrix(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
