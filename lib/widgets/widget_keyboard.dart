import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/models/model_board_letter.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:dartx/dartx.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boardBloc = context.watch<BoardBloc>();
    List<BoardLetter> uniqTypedLetterList = [];
    var typedLetterList = boardBloc.state.submittedWordList.flatten().toList();
    // process the unqList
    typedLetterList.forEach((element) {
      // do nothing, if the board letter already there
      var inUniqList = uniqTypedLetterList.contains(element);
      if (inUniqList) {
        return;
      }
      // check if the letter is already in the uniqList aka [found-letter]
      var letterInUniqList = uniqTypedLetterList
          .filter((unEl) => unEl.letter == element.letter)
          .toList();
      // if there is no [found-letter], add [current-checked-letter]
      if (letterInUniqList.isEmpty) {
        uniqTypedLetterList.add(element);
      }
      // if there is one, process the [current-checked-letter]
      else {
        // if the [current-checked-letter] is black
        // if the [found-letter] is green
        // do nothing
        if (element.color == BoardColors.base ||
            letterInUniqList[0].color == BoardColors.pinpoint) {
          return;
        }
        // if the [found-letter] is not green (yellow/black)
        // --------
        // if the the [current-checked-letter] is green
        else if (element.color == BoardColors.pinpoint) {
          // remove the non green [found-letter] and add the [current-checked-letter] (green)
          uniqTypedLetterList.remove(letterInUniqList[0]);
          uniqTypedLetterList.add(element);
        }
        // if the [current-checked-letter] is yellow
        // and the [found-letter] is black
        // remove the black [found-letter] and add the [current-checked-letter] (yellow)
        else if (element.color == BoardColors.okLetter &&
            letterInUniqList[0].color == BoardColors.base) {
          uniqTypedLetterList.remove(letterInUniqList[0]);
          uniqTypedLetterList.add(element);
        }
      }
    });
    // add yellow ones
    // typedLetterList.forEach((element) {
    //   if () {
    //     uniqTypedLetterList.add(element);
    //   }
    // });

    // var
    TextStyle getTextStyle() => const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        );

    Color? _getColor(String key) {
      var letterTarget = uniqTypedLetterList
          .where((element) => element.letter == key)
          .toList();
      if (letterTarget.isNotEmpty) {
        return letterTarget[0].color;
      }
      return Colors.blueGrey;
    }

    void _onTap(String key) {
      // if (boardBloc.state is BoardSubmitted) {
      //   // print('submitted');
      //   return;
      // }
      if (key == "BACKSPACE") {
        boardBloc.add(BoardRemoveLetter());
      } else if (key == "ENTER") {
        boardBloc.add(BoardSubmitWord());
      } else {
        boardBloc.add(BoardAddLetter(letter: key));
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
          color: _getColor(key),
          child: InkWell(
            onTap:
                boardBloc.state is! BoardSubmitted ? () => _onTap(key) : null,
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
          // Text('${boardBloc.state.toString()}'),
          ..._keyboardButtons,
        ],
      ),
    );
  }
}
