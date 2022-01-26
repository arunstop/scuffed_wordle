import 'dart:math';

import 'package:dartx/dartx.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/models/model_board_letter.dart';
import 'package:scuffed_wordle/ui.dart';

class Board extends StatefulWidget {
  Board({Key? key, required this.rows, required this.cols}) : super(key: key);

  final int rows;
  final int cols;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  void initState() {
    // TODO: implement initState

    // context.bloc<DictionaryBloc>.add(DictionaryInit());
    _loadWordList();

    super.initState();
  }

  _loadWordList() async {
    var validWordList = await Dictionary.getValidWordList(context);
    // print(validWordList.length);
    var keywordList = await Dictionary.getKeywordList(context);
    // print(keywordList.length);
    var randomKeyword = keywordList[Random().nextInt(keywordList.length)];
    context.read<DictionaryBloc>().add(DictionaryInitialize(
          list: validWordList,
          keyword: 'silly',
        ));
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    // Dictionary.list(context).then((value) => print(value));
    var boardBloc = context.watch<BoardBloc>();
    var settingsBloc = context.watch<SettingsBloc>();

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

    BoxShape _getShape(int row, Color? color) {
      // not changing shape if color blind is turned off
      if (settingsBloc.state.colorBlindMode == false) {
        return BoxShape.rectangle;
      } else if (boardState.attempt == row + 1) {
        return BoxShape.rectangle;
      } else if (color == BoardColors.pinpoint) {
        return BoxShape.circle;
      }
      return BoxShape.rectangle;
    }

    BoxDecoration _getDecoration(int row, Color? color) {
      BoxShape shape = _getShape(row, color);
      return BoxDecoration(
        shape: shape,
        color: _getColor(row, color),
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.all(Radius.circular(8.0))
            : null,
      );
    }

    Widget _getLetterShape(int row, int col, BoardLetter letter) {
      // Check if the letter is yellow
      bool yellowLetter = letter.color == BoardColors.okLetter;
      // Check if colorblind is on
      bool isColorBlind = settingsBloc.state.colorBlindMode;
      bool yellowAndColorBlind = yellowLetter && isColorBlind;

      double degree45 = -math.pi / 4;
      double rotation = yellowAndColorBlind ? degree45 : 0;
      double size = yellowAndColorBlind ? 48 : 60;
      return Container(
        // key: UniqueKey(),
        height: 60,
        width: 60,
        // if yellow and colorblind
        // remove parents background
        // then apply the rotated background to the child
        decoration:
            yellowAndColorBlind ? null : _getDecoration(row, letter.color),
        alignment: Alignment.center,
        // Rotate it yellow and color blind
        child: Transform.rotate(
          angle: rotation,
          child: Container(
            height: size,
            width: size,
            alignment: Alignment.center,
            // apply the rotated background to the child
            decoration:
                yellowAndColorBlind ? _getDecoration(row, letter.color) : null,
            child: Center(
              // Rotate it yellow and color blind
              child: Transform.rotate(
                angle: -rotation,
                child: Text(
                  _getLetter(row, col, letter.letter),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> wordBoard = boardBloc.state.wordList
        .mapIndexed(
          (row, word) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: word
                  .mapIndexed(
                    (col, letter) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: _getLetterShape(row, col, letter),
                    ),
                  )
                  .toList()),
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
          // Text('${DictionaryBloc.state.list.length}'),
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
