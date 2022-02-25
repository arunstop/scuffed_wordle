import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';
import 'package:scuffed_wordle/ui.dart';
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
    bool _isPlaying = boardState is! BoardGameOver;

    String _getLetter(int row, int col, String letter) {
      // Show the letter of the current answer if the based on attempt
      // when the board is not submitted
      if (boardState.attempt == row + 1 && _isPlaying) {
        return boardState.word.length > col ? boardState.word[col] : '';
      }
      return letter;
    }

    Color? _getColor(int row, Color? color) {
      // Change current attempt row's color
      // when the board is not submitted
      return boardState.attempt == row + 1 && _isPlaying
          ? ColorLib.tileActiveRow
          : color;
    }

    Widget _getTile(int row, int col, BoardLetter letter) {
      // Check if colorblind is on
      bool isColorBlind = settingsBloc.state.settings.colorBlindMode;
      bool isOnCurrentGuess = row+1 == boardState.attempt && _isPlaying;
      return BoardTile(
              isColorBlind: isColorBlind,
              letter: _getLetter(row, col, letter.letter),
              // null safty
              color: _getColor(row, letter.color)!,
              onStandBy: row+1 > boardState.attempt,
              onType:isOnCurrentGuess &&  col == boardState.word.length,
              isWaitingToBeTyped:isOnCurrentGuess &&  col > boardState.word.length,
            );
    }

    List<Widget> wordBoard = boardBloc.state.wordList
        .mapIndexed(
          (row, word) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: word
                .mapIndexed(
                  (col, letter) => _getTile(row, col, letter),
                )
                .toList(),
          ),
        )
        .toList();

    return Flexible(
      child: Center(
        child: FittedBox(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // TextButton(onPressed: ()=> dictionaryBloc.add(DictionaryTest()), child: Text('ENC/DEC')),
                // Row(children: [
                //   Text("${_start}"),
                //   TextButton(
                //     onPressed: () {},
                //     child: Text('Start'),
                //   )
                // ]),
                ...wordBoard,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
