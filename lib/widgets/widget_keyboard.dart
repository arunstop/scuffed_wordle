import 'package:flutter/material.dart';

class Keyboard extends StatefulWidget {
  Keyboard({Key? key}) : super(key: key);

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  List<List<String>> _keyboardKeys = [
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
  List<Widget> _keyboardButtons = [];

  @override
  void initState() {
    super.initState();
    for (var rowKeys in _keyboardKeys) {
      Widget _getKey(String key) {
        double _w = 60;
        double _h = 36;
        Widget _label = Text(key);
        if (key == 'ENTER' || key == 'BACKSPACE') {
          _h = _h * 2;
          _label = key == 'ENTER'
              ? Text(key, style: TextStyle(fontWeight: FontWeight.bold))
              : _label;
          _label = key == 'BACKSPACE' ? const Icon(Icons.backspace) : _label;
        }
        return SizedBox(
          height: _w,
          width: _h,
          child: Card(
            color: Colors.greenAccent,
            child: Center(
              child: _label,
            ),
          ),
        );
      }

      _keyboardButtons.add(
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [for (var key in rowKeys) _getKey(key)],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsetsDirectional.all(6),
      child: Column(
        children: [..._keyboardButtons],
      ),
    );
  }
}
