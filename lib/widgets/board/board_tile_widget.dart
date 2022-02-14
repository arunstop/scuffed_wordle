import 'package:flutter/material.dart';
import 'package:scuffed_wordle/data/models/board/board_letter_model.dart';
import 'dart:math' as math;

import 'package:scuffed_wordle/ui.dart';

class BoardTile extends StatelessWidget {
  final bool isColorBlind;
  final String letter;
  final Color color;
  const BoardTile(
      {Key? key,
      required this.isColorBlind,
      required this.letter,
      required this.color})
      : super(key: key);

  BoxShape _getShape(Color? color) {
    // not changing shape if color blind is turned off
    if (isColorBlind == false) {
      return BoxShape.rectangle;
      // } else if (boardState.attempt == row + 1) {
      //   return BoxShape.rectangle;
    } else if (color == ColorList.tilePinpoint) {
      return BoxShape.circle;
    }
    return BoxShape.rectangle;
  }

  BoxDecoration _getDecoration(Color? color) {
    BoxShape shape = _getShape(color);
    return BoxDecoration(
      shape: shape,
      color: color,
      borderRadius: shape == BoxShape.rectangle
          ? BorderRadius.all(Radius.circular(8.0))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if the letter is yellow
    bool yellowLetter = color == ColorList.tileOkLetter;
    // Check if colorblind is on
    // bool isColorBlind = settingsBloc.state.settings.colorBlindMode;
    bool yellowAndColorBlind = yellowLetter && isColorBlind;

    double degree45 = -math.pi / 4;
    double rotation = yellowAndColorBlind ? degree45 : 0;
    double size = yellowAndColorBlind ? 48 : 60;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        // key: UniqueKey(),
        height: 60,
        width: 60,
        // if yellow and colorblind
        // remove parents background
        // then apply the rotated background to the child
        decoration: yellowAndColorBlind ? null : _getDecoration(color),
        alignment: Alignment.center,
        // Rotate it yellow and color blind
        child: Transform.rotate(
          angle: rotation,
          child: Container(
            height: size,
            width: size,
            alignment: Alignment.center,
            // apply the rotated background to the child
            decoration: yellowAndColorBlind ? _getDecoration(color) : null,
            child: Center(
              // Rotate it yellow and color blind
              child: Transform.rotate(
                angle: -rotation,
                child: Text(
                  letter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: 'Rubik'
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
