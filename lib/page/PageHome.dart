import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/counter_cubit.dart';
import 'package:scuffed_wordle/bloc/letter/board_bloc.dart';
import 'package:scuffed_wordle/page/PageSettings.dart';
import 'package:scuffed_wordle/widget/WidgetKeyboard.dart';
import 'package:scuffed_wordle/widget/WidgetWordBoard.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  int _counter = 0;

  void _doNavigate() {
    Navigator.pushNamed(context, '/settings');
  }

  static const int _rows = 6;
  static const int _cols = 5;
  final List<Widget> _wordTable = [
    for (var r = 1; r <= _rows; r++)
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var c = 1; c <= _cols; c++)
            TextButton(
              child: Text('${r.toString()}x${c.toString()}'),
              onPressed: () {},
            )
        ],
      )
  ];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BoardBloc(),
      child: BlocBuilder<BoardBloc, String>(
        builder: (context, count) => RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (event) {
            final key = event.logicalKey;
            if (event is RawKeyUpEvent) {
              context.read<BoardBloc>().add(BoardAdd(letter: key.keyLabel));
              print(key.keyLabel);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              // Here we take the value from the PageHome object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(widget.title),
              actions: [
                IconButton(
                  onPressed: () => _doNavigate(),
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$count'),
                WidgetWordBoard(rows: 6, cols: 5),
                Container(
                  alignment: Alignment.bottomCenter,
                  color: Theme.of(context).colorScheme.secondary,
                  child: WidgetKeyboard(),
                )
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}
