import 'package:flutter/material.dart';

dynamic _doNothing() {}

class UiController {
  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String labelActionN = 'Cancel',
    Function actionN = _doNothing,
    String labelActionY = 'OK',
    Function actionY = _doNothing,
  }) {
    const _bold = FontWeight.bold;
    final _colorScheme = Theme.of(context).colorScheme;
    Text _btnLabel(String label) => Text(
          label,
          style: const TextStyle(fontWeight: _bold, fontSize: 16),
        );

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: _bold, color: _colorScheme.primary),
        ),
        content: Text(content),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () {
              actionN();
              Navigator.pop(context, 'Cancel');
            },
            child: _btnLabel(labelActionN),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(96, 48)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              actionY();
              Navigator.pop(context, 'OK');
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(_colorScheme.primary),
              minimumSize: MaterialStateProperty.all(const Size(96, 48)),
            ),
            child: _btnLabel(labelActionY),
          ),
        ],
      ),
    );
  }

  static void showSnackbar({
    required BuildContext context,
    required String message,
    String actionLabel = 'OK',
    Function action = _doNothing,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: () => action,
        textColor: Theme.of(context).colorScheme.primary,
      ),
    ));
  }

  static List<List<String>> keyboardTemplate = [
    [
      'Q',
      'W',
      'E',
      'R',
      'T',
      'Y',
      'U',
      'I',
      'O',
      'P',
    ],
    [
      'A',
      'S',
      'D',
      'F',
      'G',
      'H',
      'J',
      'K',
      'L',
    ],
    [
      'ENTER',
      'Z',
      'X',
      'C',
      'V',
      'B',
      'N',
      'M',
      'BACKSPACE',
    ]
  ];
  static List<String> keyboardKeys = keyboardTemplate.expand((element) => element).toList();
}
