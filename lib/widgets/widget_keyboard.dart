import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:dartx/dartx.dart';

class Keyboard extends StatefulWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  bool _onKeyHeld = false;
  // Timer _initialDelay(VoidCallback callback) {
  //   return Timer(const Duration(milliseconds: 600), () {
  //     callback();
  //   });
  // }
  bool _initialHold = true;

  void _setKeyHeld(bool val) {
    // _initialDelay(() {}).cancel();
    _initialHold = true;
    _onKeyHeld = val;
  }

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = context.watch<BoardBloc>();
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
        if (element.color == ColorLib.tileBase ||
            letterInUniqList[0].color == ColorLib.tilePinpoint) {
          return;
        }
        // if the [found-letter] is not green (yellow/black)
        // --------
        // if the the [current-checked-letter] is green
        else if (element.color == ColorLib.tilePinpoint) {
          // remove the non green [found-letter] and add the [current-checked-letter] (green)
          uniqTypedLetterList.remove(letterInUniqList[0]);
          uniqTypedLetterList.add(element);
        }
        // if the [current-checked-letter] is yellow
        // and the [found-letter] is black
        // remove the black [found-letter] and add the [current-checked-letter] (yellow)
        else if (element.color == ColorLib.tileOkLetter &&
            letterInUniqList[0].color == ColorLib.tileBase) {
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
          // fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18,
        );

    Color? getColor(String key) {
      var letterTarget = uniqTypedLetterList
          .where((element) => element.letter == key)
          .toList();
      if (letterTarget.isNotEmpty) {
        return letterTarget[0].color;
      }
      return Colors.blueGrey;
    }

    void pressKey(String key) {
      if (key == "BACKSPACE") {
        if (boardBloc.state.isGuessEmpty) {
          return;
        }
        // print(key);
        boardBloc.add(BoardRemoveLetter());
      } else if (key == "ENTER") {
        // if(!boardBloc.state.isGuessFull){
        //   return;
        // }
        // print(key);
        Dictionary dictionary = dictionaryBloc.state.dictionary;
        boardBloc.add(BoardSubmitGuess(
            settings: settingsBloc.state.settings,
            answer: dictionary.answer,
            wordList: dictionary.wordList));
      } else {
        if (boardBloc.state.isGuessFull) {
          // print('submitted');
          return;
        }
        // print(key);
        boardBloc.add(BoardAddLetter(letter: key));
      }
      // print(key);
    }

    BorderRadius getBorderRadius(double bottomLeft, double topLeft,
            double topRight, double bottomRight) =>
        BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeft),
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomRight: Radius.circular(bottomRight),
        );

    Widget getKey(String key) {
      double width = 48;
      double height = 30;
      Widget label = Text(key, style: getTextStyle());
      bool nonLetter = key == 'BACKSPACE' || key == 'ENTER';
      Color? color = ColorLib.gameAlt;
      BorderRadius borderRadius = BorderRadius.circular(6);
      if (nonLetter) {
        // height = height * 2;
        if (key == 'BACKSPACE') {
          label = const Icon(
            Icons.backspace_outlined,
            color: Colors.white,
            size: 30,
          );
          // borderRadius = _getBorderRadius(60, 60, 12,12);
        } else if (key == 'ENTER') {
          label = const Icon(
            Icons.keyboard_return_rounded,
            color: Colors.white,
            size: 30,
          );
          // borderRadius = _getBorderRadius(12,12, 60, 60);
          color = ColorLib.gameMain;
        }
      } else {
        color = getColor(key);
      }
      return Expanded(
        flex: nonLetter ? 9 : 6,
        child: Container(
          height: 60,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            margin: const EdgeInsets.all(2),
            color: color,
            child: InkWell(
              child: Center(
                child: FittedBox(child: label),
              ),
              borderRadius: borderRadius,
              onTap: boardBloc.state is BoardGameOver
                  ? null
                  : () {
                      // if (_onKeyHeld == false) {
                      // if (_onKeyHeld) {
                      // onTap(key);
                      // }
                      // print('bsp');
                      _setKeyHeld(false);
                      // }
                    },
              // onLongPress: (){
              //   print('skl');
              // },
              onTapDown: (details) async {
                if (key == "ENTER") {
                  pressKey(key);
                  return;
                } else {
                  // Enable holding state
                  _setKeyHeld(true);
                  // if (_initialHold) {
                  //   await Future.delayed(Duration(milliseconds: 2000));
                  //   setState(() {
                  //     _initialHold = false;
                  //   });
                  // }
                  do {
                    // initial delay
                    pressKey(key);
                    // delay first
                    if (_initialHold) {
                      await Future.delayed(Duration(milliseconds: 600));
                      setState(() {
                        _initialHold = false;
                      });
                    } else {
                      await Future.delayed(Duration(milliseconds: 1));
                    }
                  } while (_onKeyHeld == true);

                  _setKeyHeld(false);
                } 
              },
              onTapCancel: () {
                _setKeyHeld(false);
              },
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
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
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
