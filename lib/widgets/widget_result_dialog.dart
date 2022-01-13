import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scuffed_wordle/bloc/board/bloc.dart';
import 'package:scuffed_wordle/ui.dart';

class DialogResult extends StatelessWidget {
  const DialogResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<BoardBloc>();

    return Column(
      children: [
        Text('The word was : ${UiController.keyWord}'),
        SizedBox(
          height: 12,
        ),
        Text('You guessed in ${bloc.state.attempt} attempts! Be proud!'),
      ],
    );
  }
}
