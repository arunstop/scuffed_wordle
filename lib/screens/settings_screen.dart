import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
// import 'package:scuffed_wordle/data/models/model_settings.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/widget_screen_template.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var settingsBloc = context.watch<SettingsBloc>();
    var boardBloc = context.watch<BoardBloc>();
    var state = settingsBloc.state;

    void _changeSettings(SettingsTypes type, bool value) {
      settingsBloc.add(SettingsChange(type: type, value: value));
    }

    void _showResetDialog() {
      UiController.showConfirmationDialog(
        context: context,
        title: 'Reset Settings',
        content: 'Do you wish to restore all your settings to default?',
        actionY: () {
          settingsBloc.add(SettingsReset());
          UiController.showSnackbar(
            context: context,
            message: 'Settings has been reset to default',
            actionLabel: 'Done',
          );
        },
      );
    }

    // check if user is currently playing by checking submitted word
    bool _isPlaying = boardBloc.state is! BoardGameOver &&
        boardBloc.state.submittedWordList[0]
            .filter((element) => element.letter.isNotEmpty)
            .isNotEmpty;

    Widget _getTitle(String title) => Text(
          title,
          // style: Theme.of(context).textTheme.bodyText1
          style: const TextStyle(
            fontSize: 18,
          ),
        );

    return ScreenTemplate(
      title: widget.title,
      actions: [
        IconButton(
          onPressed: () => _showResetDialog(),
          icon: const Icon(Icons.refresh),
        )
      ],
      child: ListView(
        // padding: const EdgeInsets.all(8),
        children: [
          // Text('$_isPlaying'),
          SwitchListTile.adaptive(
            value: state.settings.hardMode,
            onChanged: (val) => _isPlaying
                ? UiController.showToast(
                    title: 'Cannot change hard mode when playing',
                    strColor: "#f44336",
                  )
                : _changeSettings(SettingsTypes.hardMode, val),
            title: _getTitle('Hard Mode'),
            subtitle: const Text('User must use the green letters they found'),
            secondary: const Icon(Icons.whatshot_rounded),
          ),
          SwitchListTile.adaptive(
            value: state.settings.darkTheme,
            onChanged: (val) => _changeSettings(SettingsTypes.darkTheme, val),
            title: _getTitle('Dark Theme'),
            secondary: const Icon(Icons.nightlight_rounded),
          ),
          SwitchListTile.adaptive(
            value: state.settings.colorBlindMode,
            onChanged: (val) =>
                _changeSettings(SettingsTypes.colorBlindMode, val),
            title: _getTitle('Color Blind Mode'),
            subtitle: const Text(
                'Give each letter in answer a shape to make it more visible to the one who needs'),
            secondary: const Icon(Icons.remove_red_eye_rounded),
          ),
          SwitchListTile.adaptive(
            value: state.settings.highContrast,
            onChanged: (val) =>
                _changeSettings(SettingsTypes.highContrast, val),
            title: _getTitle('High Contrast'),
            secondary: const Icon(Icons.brightness_6_rounded),
          ),
          SwitchListTile.adaptive(
            value: state.settings.retypeOnWrongGuess,
            onChanged: (val) =>
                _changeSettings(SettingsTypes.retypeOnWrongGuess, val),
            title: _getTitle('Re-type on wrong guess'), 
            subtitle: const Text(
                'Delete current guess when it is INVALID (not a dictionary word/does not meet the hard mode requirements)'),
            secondary: const Icon(Icons.keyboard_return_rounded),
          ),
        ],
      ),
    );
  }
}
