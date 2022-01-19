import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scuffed_wordle/bloc/board/bloc_board.dart';
import 'package:scuffed_wordle/models/model__board_letter.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:dartx/dartx.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.watch<BoardBloc>();
    var submittedWordList = bloc.state.submittedWordList
        .expand((element) => element)
        .distinctBy((element) => element.letter)
        .toSet()
        .toList();

    TextStyle getTextStyle() => const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );

    Color? getColor(String key) {
      var letterTarget =
          submittedWordList.where((element) => element.letter == key).toList();
      if (letterTarget.isNotEmpty) {
        return letterTarget[0].color;
      }
      return Colors.blueGrey;
    }

    void onTap(String key) {
      if (key == "BACKSPACE") {
        bloc.add(BoardRemoveLetter());
      } else if (key == "ENTER") {
        bloc.add(BoardSubmitWord());
      } else {
        bloc.add(BoardAddLetter(letter: key));
      }
      // print(key);
    }

    Widget getKey(String key) {
      double width = 60;
      double height = 36;
      Widget label = Text(key, style: getTextStyle());
      if (key == 'ENTER' || key == 'BACKSPACE') {
        height = height * 2;
        label = key == 'ENTER' ? Text(key, style: getTextStyle()) : label;
        label = key == 'BACKSPACE'
            ? const Icon(
                Icons.backspace,
                color: Colors.white,
              )
            : label;
      }
      return SizedBox(
        height: width,
        width: height,
        child: Card(
          color: getColor(key),
          child: InkWell(
            onTap: () => onTap(key),
            child: Center(
              child: label,
            ),
          ),
        ),
      );
    }

    List<Widget> _keyboardButtons = UiController.keyboardTemplate
        .map((kbRow) => Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [for (var key in kbRow) getKey(key)],
            ))
        .toList();

    return Container(
      padding: EdgeInsetsDirectional.all(6),
      child: Column(
        children: [
          // Text('${submittedWordList.map((e) => e.letter)}'),
          ..._keyboardButtons,
        ],
      ),
    );
  }
}
