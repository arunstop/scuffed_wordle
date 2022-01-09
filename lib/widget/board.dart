import 'package:flutter/material.dart';

class Board extends StatefulWidget {
  Board({Key? key, required this.rows, required this.cols})
      : super(key: key);

  final int rows;
  final int cols;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      child: Column(
        children: [
          ...wordBoard,
        ],
      ),
    );
  }
}
