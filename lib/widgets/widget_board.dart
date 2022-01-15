import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/bloc.dart';
import 'package:scuffed_wordle/ui.dart';

class Board extends StatelessWidget {
  Board({Key? key, required this.rows, required this.cols}) : super(key: key);

  final int rows;
  final int cols;

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<BoardBloc>();
    String _getLetter(int row, int column) {
      var state = bloc.state;
      if (state.attempt == row && column <= state.word.length) {
        // if(column == state.word.length) {
        return state.word[column - 1];
        // } else if(column < state.word.length) {
        // return state.word[column - 1];
        // }
      }
      return state.wordList[row - 1][column - 1].letter;
    }

    Color? _getColor(int row, int column) {
      var state = bloc.state;
      return state.attempt == row
          ? BoardColors.activeRow
          : state.wordList[row - 1][column - 1].color;
    }

    String _getText2(int index) {
      var flattenWordList = bloc.state.wordList.expand((e) => e).toList();
      var state = bloc.state;
      var colIndex = (index % cols);
      var rowIndex = ((index + 1) / cols).ceil();
      if (state.attempt == rowIndex && colIndex < state.word.length) {
        // if(column == state.word.length) {
        return state.word[colIndex];
      }
      return flattenWordList[index].letter;
    }

    Color? _getColor2(int index) {
      var flattenWordList = bloc.state.wordList.expand((e) => e).toList();
      var rowIndex = ((index + 1) / cols).ceil();
      if (rowIndex == bloc.state.attempt) return BoardColors.activeRow;
      return flattenWordList[index].color;
    }

    List<Widget> wordBoard = [
      for (var r = 1; r <= rows; r++)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var c = 1; c <= cols; c++)
              SizedBox(
                // key: UniqueKey(),
                height: 60,
                width: 60,
                child: Card(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      _getLetter(r, c),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  // color: Theme.of(context).colorScheme.secondary,
                  color: _getColor(r, c),
                ),
              )
          ],
        )
    ];

    // print('build');
    // List<Widget> wordBoard = [
    //   for (var word in bloc.state.wordList)
    //     Row(
    //       children: [
    //         for (var letter in word)
    //           SizedBox(
    //             height: 60,
    //             width: 60,
    //             child: Card(
    //               child: Container(
    //                 alignment: Alignment.center,
    //                 child: Text('$letter'),
    //               ),
    //               // color: Theme.of(context).colorScheme.secondary,
    //               color: Colors.red,
    //             ),
    //           )
    //       ],
    //     ),
    // ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Column(
        children: [
          // Text('${bloc.state.word}'),
          ...wordBoard,
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
