import 'package:dartx/dartx.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';
import 'package:scuffed_wordle/data/repositories/dictionary_repository.dart';
import 'package:scuffed_wordle/data/services/dictionary_service.dart';
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
    var dictionaryBloc = context.watch<DictionaryBloc>();

    var boardState = context.watch<BoardBloc>().state;

    String _getLetter(int row, int col, String letter) {
      // Show the letter of the current answer if the based on attempt
      // when the board is not submitted
      if (boardState.attempt == row + 1 && boardState is! BoardSubmitted) {
        return boardState.word.length > col ? boardState.word[col] : '';
      }
      return letter;
    }

    Color? _getColor(int row, Color? color) {
      // Change current attempt row's color
      // when the board is not submitted
      return boardState.attempt == row + 1 && boardState is! BoardSubmitted
          ? BoardColors.activeRow
          : color;
    }

    Widget _getTile(int row, int col, BoardLetter letter) {
      // Check if the letter is yellow
      bool yellowLetter = letter.color == BoardColors.okLetter;
      // Check if colorblind is on
      bool isColorBlind = settingsBloc.state.settings.colorBlindMode;
      bool yellowAndColorBlind = yellowLetter && isColorBlind;

      double degree45 = -math.pi / 4;
      double rotation = yellowAndColorBlind ? degree45 : 0;
      double size = yellowAndColorBlind ? 48 : 60;
      return BoardTile(
        isColorBlind: isColorBlind,
        letter: _getLetter(row, col, letter.letter),
        // null safty
        color: _getColor(row, letter.color)!,
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

    //  Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         for (var col in row)
    //           SizedBox(
    //             // key: UniqueKey(),
    //             height: 60,
    //             width: 60,
    //             child: Card(
    //               child: Container(
    //                 alignment: Alignment.center,
    //                 child: Text(
    //                   _getLetter(row, col),
    //                   style: const TextStyle(
    //                     color: Colors.white,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 30,
    //                   ),
    //                 ),
    //               ),
    //               // color: Theme.of(context).colorScheme.secondary,
    //               color: _getColor(row, col),
    //             ),
    //           )
    //       ],
    //     ),

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Column(
        children: [
          // Text('${dictionaryBloc.state.keyword} ${boardBloc.state.attempt}'),
          // Text(
          //     '${boardBloc.boardRepo.getLocalGuessWordList(answerWord: dictionaryBloc.state.keyword)}'),
          ...wordBoard,
          // FutureBuilder<List<dynamic>>(
          //   future: Dictionary.list(
          //       context), // a previously-obtained Future<String> or null
          //   builder:
          //       (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          //     return Text('${snapshot.data?.length}');
          //   },
          // ),

          // Text(
          //     '${bloc.state.wordList.expand((e) => e).map((e) => e.letter).toList()}'),
          // GridView.count(
          //   shrinkWrap: true,
          //   crossAxisCount: cols,
          //   children: List.generate(
          //     rows * cols,
          //     (index) => SizedBox(
          //       // key: UniqueKey(),
          //       // height: 60,
          //       // width: 60,
          //       child: Card(
          //         child: Container(
          //           alignment: Alignment.center,
          //           child: Text(
          //             _getText2(index),
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 30,
          //             ),
          //           ),
          //         ),
          //         // color: Theme.of(context).colorScheme.secondary,
          //         color: _getColor2(index),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
