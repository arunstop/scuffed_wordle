import 'package:flutter/material.dart';
import 'package:scuffed_wordle/page/PageSettings.dart';
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
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
      body: Align(
        alignment: Alignment.center,
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: WidgetWordBoard(rows: 6, cols: 5)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
