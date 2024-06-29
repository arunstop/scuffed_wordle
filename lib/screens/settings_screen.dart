import 'package:flutter/foundation.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/data/constants.dart';
import 'package:scuffed_wordle/data/models/language/languange_model.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/models/status_model.dart';
// import 'package:scuffed_wordle/data/models/model_settings.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/widget_screen_template.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    SettingsBloc settingsBloc = context.watch<SettingsBloc>();
    BoardBloc boardBloc = context.watch<BoardBloc>();
    DictionaryBloc dictionaryBloc = context.watch<DictionaryBloc>();
    Settings settings = settingsBloc.state.settings;

    void changeSettings(SettingsTypes type, dynamic value) {
      settingsBloc.add(SettingsChange(type: type, value: value));
    }

    void showResetDialog() {
      UiLib.showConfirmationDialog(
        context: context,
        title: 'Reset Settings',
        content: 'Do you wish to restore all your settings to default?',
        actionY: () {
          settingsBloc.add(SettingsReset());
          // UiLib.showSnackbar(
          //   context: context,
          //   message: 'Settings has been reset to default',
          //   actionLabel: 'Done',
          // );
          UiLib.showToast(
            status: Status.def,
            text: "Settings has been reset to default",
          );
        },
      );
    }

    // check if user is currently playing by checking submitted word
    bool isPlaying =
        boardBloc.state is! BoardGameOver && boardBloc.state.attempt > 1;

    Widget getTitle(String title) => Text(
          title,
          // style: Theme.of(context).textTheme.bodyText1
          style: const TextStyle(
            fontSize: 18,
          ),
        );
    bool _isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    Widget wDropDown<T>({
      required T value,
      required List<T> items,
      required Function onChanged,
    }) =>
        Container(
          // color: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items.map<DropdownMenuItem<T>>((e) {
                return DropdownMenuItem<T>(
                  value: e,
                  child: Text(e is TranslationLanguage
                      ? (e as TranslationLanguage).language
                      : e.toString()),
                );
              }).toList(),
              onChanged: (value) => onChanged(value),
            ),
          ),
        );

    Widget wHardMode() => SwitchListTile.adaptive(
          value: settings.hardMode,
          onChanged: (val) {
            if (isPlaying) {
              UiLib.showToast(
                status: Status.error,
                text: 'Cannot change hard mode when playing',
              );
              return;
            }
            changeSettings(SettingsTypes.hardMode, val);
          },
          title: getTitle('Hard Mode'),
          subtitle: const Text('User must use the green letters they found'),
          secondary: const Icon(Icons.whatshot_rounded),
        );

    Widget wDarkTheme() => SwitchListTile.adaptive(
          value: settings.darkTheme,
          onChanged: (val) => changeSettings(SettingsTypes.darkTheme, val),
          title: getTitle('Dark Theme'),
          secondary: const Icon(Icons.nightlight_rounded),
        );

    Widget wColorBlindMode() => SwitchListTile.adaptive(
          value: settings.colorBlindMode,
          onChanged: (val) => changeSettings(SettingsTypes.colorBlindMode, val),
          title: getTitle('Color Blind Mode'),
          subtitle: const Text(
              'Give each letter in answer a shape to make it more visible to the one who needs'),
          secondary: const Icon(Icons.remove_red_eye_rounded),
        );

    Widget wHighContrast() => SwitchListTile.adaptive(
          value: settings.highContrast,
          onChanged: (val) => changeSettings(SettingsTypes.highContrast, val),
          title: getTitle('High Contrast'),
          secondary: const Icon(Icons.brightness_6_rounded),
        );

    Widget wRetypeOnWrongGuess() => SwitchListTile.adaptive(
          value: settings.retypeOnWrongGuess,
          onChanged: (val) =>
              changeSettings(SettingsTypes.retypeOnWrongGuess, val),
          title: getTitle('Re-type on wrong guess'),
          subtitle: const Text('Delete current guess when it is INVALID'),
          secondary: const Icon(Icons.keyboard_return_rounded),
        );

    Widget wMatrix() => ListTile(
          leading: const Icon(Icons.apps_rounded),
          title: const Text('Game Matrix'),
          subtitle: const Text(
              'Choose word length, between 4-8. The attempts is [word length + 1].'),
          onTap: () {
            print('change');
          },
          trailing: wDropDown<String>(
            value: settings.matrix,
            items: Constants.matrixList,
            onChanged: (String value) {
              if (isPlaying) {
                UiLib.showToast(
                  status: Status.error,
                  text: 'Cannot change game matrix when playing',
                );
              } else {
                if (value == settings.matrix) {
                  return;
                }
                changeSettings(SettingsTypes.matrix, value);
                // print(value);
                // print(settings.wordLength);
                dictionaryBloc.add(DictionaryInitialize());
                boardBloc.add(
                  BoardRestart(
                      // length: settings.guessLength,
                      // lives: settings.lives,
                      ),
                );
                Navigator.pop(context);
              }
            },
          ),
        );

    Widget wDifficulty() => ListTile(
          leading: const Icon(Icons.apps_rounded),
          title: const Text('Game Difficulty'),
          subtitle: const Text('Choose difficulty: Easy, Normal, Hard'),
          onTap: () {
            print('diff change');
          },
          trailing: wDropDown<String>(
            value: settings.difficulty,
            items: Constants.difficultyList,
            onChanged: (String value) {
              if (isPlaying) {
                UiLib.showToast(
                  status: Status.error,
                  text: 'Cannot change game difficulty when playing',
                );
              } else {
                if (value == settings.difficulty) {
                  return;
                }
                changeSettings(SettingsTypes.difficulty, value);
                dictionaryBloc.add(DictionaryInitialize());
                // dictionaryBloc.add(DictionaryRefreshKeyword());
                boardBloc.add(BoardRestart());
                Navigator.pop(context);
              }
            },
          ),
        );

    Widget wUseMobileKeyboard() => SwitchListTile.adaptive(
          value: settings.useMobileKeyboard,
          onChanged: !_isMobile
              ? null
              : (val) => changeSettings(SettingsTypes.useMobileKeyboard, val),
          title: getTitle('Use device\'s keyboard on mobile'),
          subtitle:
              const Text('Use phone\'s default virtual keyboard instead.'),
          secondary: const Icon(Icons.keyboard_alt_outlined),
        );

    Widget wTranslationLanguage() => ListTile(
          leading: const Icon(Icons.translate_rounded),
          title: Text('Translation Language'),
          subtitle: Column(
            children: [
              Text(
                  'Choose a language to translate the answer when the game is over.'),
              UiLib.vSpace(6),
              Align(
                alignment: Alignment.centerRight,
                child: FutureBuilder<List<TranslationLanguage>>(
                  future: Constants.getLangList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // find translationLanguage based on string of settings.translationLanguage
                      var transLanguageByIsoCode = snapshot.data!.firstWhere(
                          (element) =>
                              element.isoCode.toLowerCase() ==
                              settings.translationLanguage);
                      return wDropDown<TranslationLanguage>(
                          value: transLanguageByIsoCode,
                          items: snapshot.data!,
                          onChanged: (TranslationLanguage value) {
                            changeSettings(SettingsTypes.translationLanguage,
                                value.isoCode.toLowerCase());
                          });
                    }
                    return Text(settings.translationLanguage);
                  },
                ),
              ),
              UiLib.vSpace(6),
            ],
          ),
        );
    List<Widget> _settingsList = [
      // Text('$_isPlaying'),
      wHardMode(),
      wDarkTheme(),
      wColorBlindMode(),
      wHighContrast(),
      wRetypeOnWrongGuess(),
      wMatrix(),
      wDifficulty(),
      wTranslationLanguage(),
      wUseMobileKeyboard(),
      UiLib.vSpace(30),
    ];

    return ScreenTemplate(
      title: title,
      actions: [
        IconButton(
          onPressed: () => showResetDialog(),
          icon: const Icon(Icons.refresh),
        )
      ],
      child: ListView(
        // padding: const EdgeInsets.all(8),
        children: _settingsList,
      ),
    );
  }
}
