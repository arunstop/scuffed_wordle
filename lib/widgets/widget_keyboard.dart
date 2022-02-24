import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:dartx/dartx.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var boardBloc = context.watch<BoardBloc>();
    DictionaryBloc dictionaryBloc = context.watch<DictionaryBloc>();
    SettingsBloc settingsBloc = context.watch<SettingsBloc>();

    List<BoardLetter> uniqTypedLetterList = [];
    var typedLetterList = boardBloc.state.submittedWordList.flatten().toList();
    // process the unqList
    typedLetterList.forEach((element) {
      // do nothing, if the letter already in the uniqList
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
        if (element.color == ColorList.tileBase ||
            letterInUniqList[0].color == ColorList.tilePinpoint) {
          return;
        }
        // if the [found-letter] is not green (yellow/black)
        // --------
        // if the the [current-checked-letter] is green
        else if (element.color == ColorList.tilePinpoint) {
          // remove the non green [found-letter] and add the [current-checked-letter] (green)
          uniqTypedLetterList.remove(letterInUniqList[0]);
          uniqTypedLetterList.add(element);
        }
        // if the [current-checked-letter] is yellow
        // and the [found-letter] is black
        // remove the black [found-letter] and add the [current-checked-letter] (yellow)
        else if (element.color == ColorList.tileOkLetter &&
            letterInUniqList[0].color == ColorList.tileBase) {
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
    TextStyle _getTextStyle() => const TextStyle(
          // fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18,
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
        Dictionary dictionary = dictionaryBloc.state.dictionary;
        boardBloc.add(BoardSubmitGuess(
            settings: settingsBloc.state.settings,
            answer: dictionary.answer,
            wordList: dictionary.wordList));
      } else {
        boardBloc.add(BoardAddLetter(letter: key));
      }
      // print(key);
    }

    Widget getKey(String key) {
      double width = 48;
      double height = 30;
      Widget label = Text(key, style: _getTextStyle());
      bool nonLetter = key == 'ENTER' || key == 'BACKSPACE';
      if (nonLetter) {
        height = height * 2;
        label = key == 'ENTER'
            ? const Icon(
                Icons.keyboard_return_rounded,
                color: Colors.white,
                size: 30,
              )
            : label;
        label = key == 'BACKSPACE'
            ? const Icon(
                Icons.backspace_outlined,
                color: Colors.white,
                size: 30,
              )
            : label;
      }
      return Expanded(
        flex: nonLetter ? 9 : 6,
        child: SizedBox(
          height: 60,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            margin: EdgeInsets.all(3),
            color: _getColor(key),
            child: InkWell(
              onTap:
                  boardBloc.state is! BoardGameOver ? () => _onTap(key) : null,
              child: Center(
                child: FittedBox(child: label),
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> _keyboardButtons = UiLib.keyboardTemplate
        .mapIndexed((index, kbRow) => Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Give 2nd row, a spacer
                index == 1
                    ? Expanded(flex: 3, child: Container())
                    : Container(),
                for (var key in kbRow) getKey(key),
                index == 1
                    ? Expanded(flex: 3, child: Container())
                    : Container(),
              ],
            ))
        .toList();

    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          // Text('${boardBloc.state.toString()}'),
          ..._keyboardButtons,

          // Row(
          //   // mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Expanded(
          //       flex: 1,
          //       child: Container(
          //         color: Colors.blue,
          //         child: Text('123'),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         color: Colors.red,
          //         child: Text('123'),
          //       ),
          //     ),
          //     Expanded(
          //       child: Container(
          //         color: Colors.green,
          //         child: Text('123'),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
