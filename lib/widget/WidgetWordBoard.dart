import 'package:flutter/material.dart';

class WidgetWordBoard extends StatefulWidget {
  WidgetWordBoard({Key? key, required this.rows, required this.cols})
      : super(key: key);

  final int rows;
  final int cols;

  @override
  _WidgetWordBoardState createState() => _WidgetWordBoardState();
}

class _WidgetWordBoardState extends State<WidgetWordBoard> {
  List<Widget> wordBoard = [];

  @override
  void initState() {
    super.initState();
    // ColorScheme _color = Theme.of(context).colorScheme;
    wordBoard = [
      for (var r = 1; r <= widget.rows; r++)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var c = 1; c <= widget.cols; c++)
              SizedBox(
                height: 60,
                width: 60,
                child: Card(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('${r.toString()}x${c.toString()}'),
                  ),
                  // color: Theme.of(context).colorScheme.secondary,
                  color: Colors.red,
                ),
              )
          ],
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...wordBoard,
        // Container(
        //     color: Theme.of(context).colorScheme.secondary,
        //     child: Text(
        //       'Text with a background color',
        //       style: Theme.of(context).textTheme.headline6,
        //     ),
        //   ),
        //   Card(
        //           child: Text('123'),
        //           // color: Theme.of(context).colorScheme.secondary,
        //           color: Theme.of(context).colorScheme.secondary,
        //         )
      ],
    );
  }
}
