import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/board/board_tile_widget.dart';
import 'package:scuffed_wordle/widgets/widget_screen_template.dart';

class HowToPlayScreen extends StatelessWidget {
  final String title;
  const HowToPlayScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isColorBlind =
        context.watch<SettingsBloc>().state.settings.colorBlindMode;

    List<Widget> _wordExample1 = [
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "T",
        color: ColorLib.tileOkLetter,
      ),
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "O",
        color: ColorLib.tileBase,
      ),
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "O",
        color: ColorLib.tileBase,
      ),
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "L",
        color: ColorLib.tileBase,
      ),
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "S",
        color: ColorLib.tileOkLetter,
      ),
    ];
    List<Widget> _wordExample2 = [
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "S",
        color: ColorLib.tilePinpoint,
      ),
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "M",
        color: ColorLib.tilePinpoint,
      ),
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "A",
        color: ColorLib.tilePinpoint,
      ),
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "L",
        color: ColorLib.tileBase,
      ),
      BoardTile(
        isColorBlind: isColorBlind,
        letter: "L",
        color: ColorLib.tileBase,
      ),
    ];

    return ScreenTemplate(
        title: title,
        child: SingleChildScrollView(
          child: Container(
            // width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Scuffed Wordle!',
                  style: Theme.of(context).textTheme.headline5,
                ),
                UiLib.vSpace(12),
                const Text(
                    "Yes, this is a wordle imitation, with some tweaks in it. How do i play this game, you asked? Simple."),
                UiLib.vSpace(6),
                const Text(
                    "So, try to find a certain word, with certain amount of guesses. So, basically just type a word and hit the Enter button."),
                UiLib.vSpace(6),
                const Text(
                    "After each guess you submitted, the tiles of each letter of your guess will change colors and/or shape. Those tiles will indicate how close your guess was to the answer."),
                UiLib.vSpace(6),
                const Text(
                    "The game condition are:\n- You found the answer, a.k.a you WIN\n- You used up all the attempts given yet still no answer, you LOSE\n- You submitted a duplicated guess, meaning you gave up and ofcourse you LOSE"),
                UiLib.vSpace(18),
                Text(
                  'For Example :',
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      // decoration: TextDecoration.underline,
                      ),
                ),
                UiLib.vSpace(12),
                const Text(
                    "We\'ll give you a 5x6 game (meaning 5 letters word and 6 attempts). Pretend that you don\'t know this, but the answer is SMART."),
                UiLib.vSpace(12),
                FittedBox(
                  child: Row(
                    children: [..._wordExample1],
                  ),
                ),
                UiLib.vSpace(12),
                const Text(
                    'Let\'s say you guessed TOOLS, so T & S are now yellow/diamond, because they exist in the answer, but in a wrong place.'),
                const Text(
                    'The letters with black tiles, are wrong in both condition, so, don\'t mind them.'),
                UiLib.vSpace(12),
                FittedBox(
                  child: Row(
                    children: [..._wordExample2],
                  ),
                ),
                UiLib.vSpace(12),
                const Text(
                    'Next one you guessed SMALL, so S, M & A are now green/circle, because they exist in the answer and are in the right place.'),
                UiLib.vSpace(12),
                const Text(
                    'Now guess the 5 letter word that:\n- Starts with S-M-A.\n- Has letter T in it but not in the first 3 letter\n- Has no letter O or L\n- Easy right?'),
                UiLib.vSpace(18),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 60),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('PLAY',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
