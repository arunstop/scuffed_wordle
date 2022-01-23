import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/models/model_settings.dart';
import 'package:scuffed_wordle/widgets/widget_screen_template.dart';

import '../ui.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  @override
  Widget build(BuildContext context) {
    var settingsBloc = context.watch<SettingsBloc>();
    var state = settingsBloc.state;

    void _changeSettings(SettingsType type, bool value) {
      settingsBloc.add(SettingsChange(type: type, value: value));
    }

    void _showResetDialog() {
      UiController.showConfirmationDialog(
        context: context,
        title: 'Reset Settings',
        content: 'Do you wish to restore all your settings to default?',
        actionY: () {
          UiController.showSnackbar(
            context: context,
            message: 'Settings has been reset to default',
            actionLabel: 'Done',
          );
        },
      );
    }

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
          SwitchListTile.adaptive(
            value: state.darkTheme,
            onChanged: (val) => _changeSettings(SettingsType.darkTheme, val),
            title: const Text('Dark Theme'),
            secondary: Icon(Icons.dark_mode),
          ),
          SwitchListTile.adaptive(
            value: state.highContrast,
            onChanged: (val) => _changeSettings(SettingsType.highContrast, val),
            title: const Text('High Contrast'),
            secondary: Icon(Icons.flare_outlined),
          ),
        ],
      ),
    );
  }
}
