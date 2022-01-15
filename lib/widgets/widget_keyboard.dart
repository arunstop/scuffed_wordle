import 'package:flutter/material.dart';
import 'package:scuffed_wordle/ui.dart';

class Keyboard extends StatefulWidget {
  Keyboard({Key? key}) : super(key: key);

  @override
  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  List<Widget> _keyboardButtons = [];

  TextStyle _getTextStyle() => const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  @override
  void initState() {
    super.initState();
    for (var rowKeys in UiController.keyboardTemplate) {
      Widget _getKey(String key) {
        double _w = 60;
        double _h = 36;
        Widget _label = Text(key, style: _getTextStyle());
        if (key == 'ENTER' || key == 'BACKSPACE') {
          _h = _h * 2;
          _label = key == 'ENTER' ? Text(key, style: _getTextStyle()) : _label;
          _label = key == 'BACKSPACE'
              ? const Icon(
                  Icons.backspace,
                  color: Colors.white,
                )
              : _label;
        }
        return SizedBox(
          height: _w,
          width: _h,
          child: Card(
            color: Colors.blueGrey[800],
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
      // color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsetsDirectional.all(6),
      child: Column(
        children: [..._keyboardButtons],
      ),
    );
  }
}
