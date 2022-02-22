import 'package:flutter/foundation.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
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

    void _changeSettings(SettingsTypes type, dynamic value) {
      settingsBloc.add(SettingsChange(type: type, value: value));
    }

    void _showResetDialog() {
      UiLib.showConfirmationDialog(
        context: context,
        title: 'Reset Settings',
        content: 'Do you wish to restore all your settings to default?',
        actionY: () {
          settingsBloc.add(SettingsReset());
          UiLib.showSnackbar(
            context: context,
            message: 'Settings has been reset to default',
            actionLabel: 'Done',
          );
        },
      );
    }

    // check if user is currently playing by checking submitted word
    bool _isPlaying =
        boardBloc.state is! BoardGameOver && boardBloc.state.attempt > 1;

    Widget _getTitle(String title) => Text(
          title,
          // style: Theme.of(context).textTheme.bodyText1
          style: const TextStyle(
            fontSize: 18,
          ),
        );
    bool _isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    List<Widget> _settingsList = [
      // Text('$_isPlaying'),
      SwitchListTile.adaptive(
        value: settings.hardMode,
        onChanged: (val) {
          if (_isPlaying) {
            UiLib.showToast(
              title: 'Cannot change hard mode when playing',
              strColor: ColorList.strError,
            );
            return;
          }
          _changeSettings(SettingsTypes.hardMode, val);
        },
        title: _getTitle('Hard Mode'),
        subtitle: const Text('User must use the green letters they found'),
        secondary: const Icon(Icons.whatshot_rounded),
      ),
      SwitchListTile.adaptive(
        value: settings.darkTheme,
        onChanged: (val) => _changeSettings(SettingsTypes.darkTheme, val),
        title: _getTitle('Dark Theme'),
        secondary: const Icon(Icons.nightlight_rounded),
      ),
      SwitchListTile.adaptive(
        value: settings.colorBlindMode,
        onChanged: (val) => _changeSettings(SettingsTypes.colorBlindMode, val),
        title: _getTitle('Color Blind Mode'),
        subtitle: const Text(
            'Give each letter in answer a shape to make it more visible to the one who needs'),
        secondary: const Icon(Icons.remove_red_eye_rounded),
      ),
      SwitchListTile.adaptive(
        value: settings.highContrast,
        onChanged: (val) => _changeSettings(SettingsTypes.highContrast, val),
        title: _getTitle('High Contrast'),
        secondary: const Icon(Icons.brightness_6_rounded),
      ),
      SwitchListTile.adaptive(
        value: settings.retypeOnWrongGuess,
        onChanged: (val) =>
            _changeSettings(SettingsTypes.retypeOnWrongGuess, val),
        title: _getTitle('Re-type on wrong guess'),
        subtitle: const Text('Delete current guess when it is INVALID'),
        secondary: const Icon(Icons.keyboard_return_rounded),
      ),
      SwitchListTile.adaptive(
        value: settings.useMobileKeyboard,
        onChanged: !_isMobile
            ? null
            : (val) => _changeSettings(SettingsTypes.useMobileKeyboard, val),
        title: _getTitle('Use device\'s keyboard on mobile'),
        subtitle: const Text('Use phone\'s default virtual keyboard instead.'),
        secondary: const Icon(Icons.keyboard_alt_outlined),
      ),
      ListTile(
        leading: const Icon(Icons.apps_rounded),
        title: const Text('Word Length'),
        subtitle: const Text(
            'Choose word length, between 4-8. The attempts is [word length + 1].'),
        onTap: () {
          print('change');
        },
        trailing: DropdownButton<String>(
          value: settings.wordLength,
          items: <String>['4x5', '5x6', '6x7', '7x8', '8x9']
              .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            if (_isPlaying) {
              UiLib.showToast(
                title: 'Cannot change game mode when playing',
                strColor: ColorList.strError,
              );
            } else {
              if (value == settings.wordLength) {
                return;
              }
              _changeSettings(SettingsTypes.wordLength, value);
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
      ),
      UiLib.vSpace(30),
    ];

    return ScreenTemplate(
      title: title,
      actions: [
        IconButton(
          onPressed: () => _showResetDialog(),
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
