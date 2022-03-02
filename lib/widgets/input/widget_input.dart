import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/widget_keyboard.dart';
import 'package:scuffed_wordle/widgets/widget_mic_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Input extends StatefulWidget {
  final int guessLength;
  Input({Key? key, required this.guessLength}) : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  bool _onVoiceInput = false;
  List<String> _detectedWords = [];

  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = context.read<BoardBloc>();

    void addGuess(String guess) {
      boardBloc.add(BoardAddGuess(guess: guess, length: widget.guessLength));
    }

    Color? getLayoutColor() {
      Color color = Theme.of(context).colorScheme.primary;
      if (_isError) {
        color = ColorLib.error;
      }
      return color.withAlpha(64);
    }

    List<Widget> wordChips() {
      return <Widget>[
        for (String word in _detectedWords)
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ActionChip(
              onPressed: () {
                addGuess(word);
              },
              backgroundColor: word.length == widget.guessLength
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
            child: !_onVoiceInput
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
                              child: _detectedWords.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          _isError
                                              ? 'Microphone has been blocked.\nPlease enable the access to continue.'
                                              : 'Try to guess the answer\nwith your beautiful voice...',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                            color: Colors.white,
                                            // backgroundColor: getLayoutColor()!
                                            //     .withAlpha(128),
                                            shadows: [
                                              Shadow(
                                                color: Colors.black,
                                                blurRadius: 1,
                                                offset: Offset(2,2),
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
          guessLength: widget.guessLength,
          toggleVoiceInput: (value, isError) {
            setState(() {
              if (value == false) {
                _detectedWords = [];
              }
              _onVoiceInput = value;
              _isError = isError;
            });
          },
          detectedWords: (value) {
            setState(() {
              // prevent same value
              if (_detectedWords.contains(value)) {
                return;
              } else if (value.contains(' ')) {
                List<String> splittedValue = value.split(' ');
                // Concat then distinct
                _detectedWords = _detectedWords
                    .followedBy(splittedValue)
                    .distinct()
                    .toList();
                return;
              }
              _detectedWords.add(value);
            });
          },
        ),
      ],
    );
  }
}
