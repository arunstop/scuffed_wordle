import 'package:flutter/material.dart';

dynamic _doNothing() {}

class UiController {
  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required dynamic content,
    String labelActionN = 'Cancel',
    Function actionN = _doNothing,
    String labelActionY = 'OK',
    Function actionY = _doNothing,
  }) {
    const _bold = FontWeight.bold;
    final _colorScheme = Theme.of(context).colorScheme;
    Widget _getContent() {
      if (content is String) {
        return Text(content);
      } else if (content is Widget) {
        return content;
      }
      return const SizedBox();
    }

    Text _btnLabel(String label) => Text(
          label,
          style: TextStyle(
            fontWeight: _bold,
            fontSize: 16,
            color: label == labelActionY ? Colors.white : Theme.of(context).colorScheme.primary,
          ),
        );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: _bold,
            color: _colorScheme.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_getContent()],
        ),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
              actionN();
            },
            child: _btnLabel(labelActionN),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(96, 48)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              actionY();
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
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
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
  static List<String> keyboardKeys =
      keyboardTemplate.expand((element) => element).toList();
  static String keyWord = "KEKWL";
}

class BoardColors {
  static var base = Colors.grey[800];
  static var activeRow = Colors.blue[800];
  static var okLetter = Colors.yellow[700];
  static var pinpoint = Colors.green;
}
