import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/ui/ui_bloc.dart';
import 'package:scuffed_wordle/data/stt.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/widget_keyboard.dart';
import 'package:scuffed_wordle/widgets/widget_mic_input.dart';

class Input extends StatelessWidget {
  final int guessLength;
  const Input({
    Key? key,
    required this.guessLength,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    UiBloc uiBloc = context.watch<UiBloc>();
    Stt uiStt = uiBloc.state.stt;
    bool isError = uiStt.isError;
    bool isShowingInput = uiStt.isShowingInput;
    List<String> detectedWords = uiStt.detectedWordList;

    BoardBloc boardBloc = context.read<BoardBloc>();

    void addGuess(String guess) {
      boardBloc.add(BoardAddGuess(guess: guess, length: guessLength));
    }

    Color? getLayoutColor() {
      Color color = Theme.of(context).colorScheme.primary;
      if (isError) {
        color = ColorLib.error;
      }
      return color.withAlpha(64);
    }

    List<Widget> wordChips() {
      return <Widget>[
        for (String word in detectedWords)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ActionChip(
              onPressed: () {
                addGuess(word);
              },
              backgroundColor: word.length == guessLength
                  ? ColorLib.gameMain
                  : ColorLib.tileBase.withAlpha(192),
              label: Text(
                '${word}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
      ];
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            // Text('${_onVoiceInput}'),
            UiLib.vSpace(12),
            const Keyboard(),
            UiLib.vSpace(48)
          ],
        ),
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              axis: Axis.vertical,
              // Bottom when Axis.vertical
              axisAlignment: 1.0,
              child: child,
            ),
            child: !isShowingInput
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      color: getLayoutColor(),
                    ),
                    key: const ValueKey<String>('voice-input-layout'),
                    alignment: Alignment.center,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 6,
                        sigmaY: 6,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: detectedWords.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          uiStt.placeholderTxt,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1!
                                              .copyWith(
                                                // fontSize: 16,
                                            color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            // backgroundColor: getLayoutColor()!
                                            //     .withAlpha(128),
                                            shadows: [
                                              Shadow(
                                                color: Colors.black,
                                                blurRadius: 3,
                                                offset: Offset(1,2),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Wrap(
                                          verticalDirection:
                                              VerticalDirection.up,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            ...wordChips(),
                                            // Text('${uiStt.lastDetectedWord}')
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          UiLib.vSpace(48)
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        MicInput(
          guessLength: guessLength,
          // toggleVoiceInput: (value, isError) {
          //   setState(() {
          //     if (value == false) {
          //       _detectedWords = [];
          //     }
          //     _onVoiceInput = value;
          //     _isError = isError;
          //   });
          // },
          // detectedWords: (value) {
          //   setState(() {
          //     // prevent same value
          //     if (_detectedWords.contains(value)) {
          //       return;
          //     } else if (value.contains(' ')) {
          //       List<String> splittedValue = value.split(' ');
          //       // Concat then distinct
          //       _detectedWords = _detectedWords
          //           .followedBy(splittedValue)
          //           .distinct()
          //           .toList();
          //       return;
          //     }
          //     _detectedWords.add(value);
          //   });
          // },
        ),
      ],
    );
  }
}
