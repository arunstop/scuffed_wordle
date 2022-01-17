import 'package:flutter/material.dart';
import 'package:scuffed_wordle/ui.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: SizedBox(
          width: 520,
          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 6,
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                title: Text(widget.title),
                // backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                actions: [
                  IconButton(
                      onPressed: () => UiController.showConfirmationDialog(
                          context: context,
                          title: 'Reset Settings',
                          content:
                              'Do you wish to restore all your settings to default?',
                          actionY: () {
                            UiController.showSnackbar(
                              context: context,
                              message: 'Settings has been reset to default',
                              actionLabel: 'Done',
                            );
                          }),
                      icon: const Icon(Icons.refresh))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
