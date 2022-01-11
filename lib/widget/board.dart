import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/bloc.dart';

class Board extends StatelessWidget {
  Board({Key? key, required this.rows, required this.cols}) : super(key: key);

  final int rows;
  final int cols;

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<BoardBloc>();
    var _wordList = bloc.state.wordList;
    String _getLetter(int row, int column) {
      if (bloc.state.attempt == row) {
        return bloc.state.word[column - 1];
      }
      return bloc.state.wordList[row - 1][column - 1];
    }

    Color? _getColor(int row, int column) {
      var letter = bloc.state.wordList[row - 1][column - 1].toLowerCase();
      if (letter == 'k') {
        return Colors.green;
      } else if (letter == 'w') {
        return Colors.orangeAccent[200];
      } else if (bloc.state.attempt == row) {
        return Colors.blue[800];
      }
      return Colors.grey[800];
    }

    List<Widget> wordBoard = [
      for (var r = 1; r <= rows; r++)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var c = 1; c <= cols; c++)
              SizedBox(
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
        ],
      ),
    );
  }
}
