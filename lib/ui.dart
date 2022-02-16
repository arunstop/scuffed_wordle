import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

dynamic _doNothing() {}

class UiController {
  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required dynamic content,
    bool noAction = false,
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
            color: label == labelActionY
                ? Colors.white
                : Theme.of(context).colorScheme.primary,
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
        actions: noAction
            ? []
            : <Widget>[
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
                    backgroundColor:
                        MaterialStateProperty.all(_colorScheme.primary),
                    minimumSize: MaterialStateProperty.all(const Size(96, 48)),
                  ),
                  child: _btnLabel(labelActionY),
                ),
              ],
      ),
    );
  }

  static void showBottomSheet({
    required BuildContext context,
    required dynamic content,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      constraints: const BoxConstraints(
        minWidth: 300,
        maxWidth: 520,
      ),
      // isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12,bottom: 12),
        child: content,
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

  static void showToast({String title = '', String strColor = '#00b09b'}) {
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      webPosition: 'center',
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      webBgColor: strColor,
      textColor: Colors.white,
    );
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
      'BACKSPACE',
      'Z',
      'X',
      'C',
      'V',
      'B',
      'N',
      'M',
      'ENTER',
    ]
  ];
  static List<String> keyboardKeys =
      keyboardTemplate.expand((element) => element).toList();
  static Widget vSpace(double h) => SizedBox(
        height: h,
      );
  static Widget hSpace(double w) => SizedBox(
        width: w,
      );
}

class ColorList {
  static Color tileBase = Colors.grey[800]!;
  static Color tileActiveRow = Colors.blue[800]!;
  static Color tileOkLetter = Colors.yellow[700]!;
  static Color tilePinpoint = Colors.green;
  static Color ok = Colors.green;
  static String strOk = "#4caf50";
  static Color error = Colors.red;
  static String strError = "#f44336";
}
