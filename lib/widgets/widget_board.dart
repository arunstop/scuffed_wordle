import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
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
    _loadDictionarys();

    super.initState();
  }

  _loadDictionarys() async {
        context.read<DictionaryBloc>().add(DictionaryInitialize(list : await Dictionary.getList(context)));
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    // Dictionary.list(context).then((value) => print(value));
    var boardBloc = context.read<BoardBloc>();
    var dictionaryBloc = context.watch<DictionaryBloc>();
    String _getLetter(int row, int column) {
      var state = boardBloc.state;
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
      var state = boardBloc.state;
      return state.attempt == row
          ? BoardColors.activeRow
          : state.wordList[row - 1][column - 1].color;
    }

    String _getText2(int index) {
      var flattenWordList = boardBloc.state.wordList.expand((e) => e).toList();
      var state = boardBloc.state;
      var colIndex = (index % widget.cols);
      var rowIndex = ((index + 1) / widget.cols).ceil();
      if (state.attempt == rowIndex && colIndex < state.word.length) {
        // if(column == state.word.length) {
        return state.word[colIndex];
      }
      return flattenWordList[index].letter;
    }

    Color? _getColor2(int index) {
      var flattenWordList = boardBloc.state.wordList.expand((e) => e).toList();
      var rowIndex = ((index + 1) / widget.cols).ceil();
      if (rowIndex == boardBloc.state.attempt) return BoardColors.activeRow;
      return flattenWordList[index].color;
    }

    List<Widget> wordBoard = [
      for (var r = 1; r <= widget.rows; r++)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var c = 1; c <= widget.cols; c++)
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
