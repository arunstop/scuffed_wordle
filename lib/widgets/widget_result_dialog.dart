import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/data/models/word_definition/word_model.dart';
import 'package:scuffed_wordle/ui.dart';

class DialogResult extends StatelessWidget {
  final String answer;
  // final Word? definition;
  const DialogResult({
    Key? key,
    required this.answer,
    // required this.definition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = context.read<BoardBloc>();
    DictionaryBloc dictionaryBloc = context.watch<DictionaryBloc>();
    Word? definition = dictionaryBloc.state.dictionary.wordDefinition;
    // Share result
    void _shareResult() {
      var state = boardBloc.state;
      // Turn the submitted boad into string format
      var resultClipBoard = state.submittedWordList.map((word) {
        return word.mapIndexed((letterIndex, letter) {
          String lineBreak = letterIndex + 1 == word.length ? "\n" : "";
          if (letter.color == ColorList.tileBase) {
            // Black
            return "⬛$lineBreak";
          } else if (letter.color == ColorList.tileOkLetter) {
            // Yellow
            return "🟨$lineBreak";
          } else if (letter.color == ColorList.tilePinpoint) {
            // Green
            return "🟩$lineBreak";
          }
        }).join();
      }).join();
      bool gameOver = state.attempt > state.attemptLimit || !state.win;
      var totalAttempt = gameOver ? 'X' : state.attempt;
      var text =
          "SCUFFED WORDLE ${totalAttempt}/${state.attemptLimit}\n\n${resultClipBoard}";
      Clipboard.setData(ClipboardData(text: text));
      //
      UiController.showSnackbar(
        context: context,
        message: 'Copied to clipboard',
      );
    }

    // Close dialog
    void _close() => Navigator.pop(context);
    // Play again
    void _playAgain() {
      _close();
      // Timer(const Duration(milliseconds: 1), () {
      boardBloc.add(BoardRestart());
      dictionaryBloc.add(DictionaryRefreshKeyword());
      // });
    }

    void _defineWord(String answer) {
      print('defineword');
      dictionaryBloc.add(DictionaryDefine(
        lang: 'en',
        word: answer,
      ));
    }

    // Bordered button
    Widget _borderedButton({
      required String label,
      Icon? icon,
      required void Function()? action,
      bool noBorder = false,
    }) =>
        SizedBox(
          width: double.infinity,
          height: 45,
          child: OutlinedButton.icon(
            onPressed: action,
            icon: icon ?? const Text(''),
            label: Text(
              label,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            // give no border coloring if noBorder is true
            style: noBorder
                ? null
                : ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
          ),
        );
    Color _resultColor = boardBloc.state.win ? ColorList.ok : ColorList.error;
    bool _isDefinitionValid = definition != null && definition.word == answer;

    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        // Text('The word was : ${answer}'),
        // Answer Chip
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'The word was : ',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontWeight: FontWeight.bold,
                      // letterSpacing: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                '${answer.toUpperCase()}',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: _resultColor,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: Column(
                children: [
                  UiController.vSpace(18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${answer}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic
                                    // letterSpacing: 2.0,
                                    // color: _resultColor,
                                    ),
                          ),
                          UiController.hSpace(9),
                          _isDefinitionValid == false
                              // Define word button
                              ? ElevatedButton.icon(
                                  onPressed: () => _defineWord(answer),
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  icon: Icon(Icons.search),
                                  label: Text('Define'),
                                )
                              : Text(
                                  '${definition!.phonetic}',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                        ],
                      ),
                      UiController.vSpace(9),
                      _isDefinitionValid == false
                          ? Text('-')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var meaning in definition!.meanings)
                                  Text(
                                      '--${meaning.partOfSpeech}--\n${meaning.definitions[0].definition}')
                              ],
                            ),
                    ],
                  ),
                  UiController.vSpace(24),
                  // Share Button
                  _borderedButton(
                    label: "Share Result",
                    icon: const Icon(Icons.share_rounded),
                    action: () => _shareResult(),
                  ),
                  UiController.vSpace(9),
                  // Play again button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton.icon(
                      onPressed: () => _playAgain(),
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Play Again",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  UiController.vSpace(9),
                  // Close button
                  _borderedButton(
                    label: "Close",
                    icon: const Icon(Icons.close_rounded),
                    action: () => _close(),
                    noBorder: true,
                  ),
                  UiController.vSpace(18),
                  // Text('You guessed in ${boardBloc.state.attempt} attempts! Be proud!'),
                  // const BoardResult(),
                ],
              ),
            ),
          ),
        )
      ],
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

    // var submittedWordList = state.wordList.sublist(0, state.attempt);
    // print(submittedWordList);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 12,
        ),
        for (var word in state.submittedWordList)
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
