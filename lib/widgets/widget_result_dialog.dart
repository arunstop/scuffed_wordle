import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scuffed_wordle/bloc/board/bloc.dart';
import 'package:scuffed_wordle/ui.dart';

class DialogResult extends StatelessWidget {
  const DialogResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<BoardBloc>();

    return Center(
      child: Column(
        children: [
          Text('The word was : ${UiController.keyWord}'),
          const SizedBox(
            height: 12,
          ),
          Text('You guessed in ${bloc.state.attempt} attempts! Be proud!'),
          const BoardResult(),
        ],
      ),
    );
  }
}

class BoardResult extends StatelessWidget {
  const BoardResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<BoardBloc>();
    var state = bloc.state;
    // Get submitted words
    // bloc.state.wordList.sublist(0,)
    // var submittedWordList = bloc.state.wordList.where((word) {
    //   var strWord = word.map((e) => e.letter).join();
    //   return strWord.isNotEmpty;
    // });

    var submittedWordList = state.wordList.sublist(0, state.attempt);
    // print(submittedWordList);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 12,
        ),
        for (var word in submittedWordList)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var letter in word)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Card(
                    color: letter.color,
                  ),
                ),
            ],
          )
      ],
    );
  }
}
