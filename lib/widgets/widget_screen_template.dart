import 'package:flutter/material.dart';

class ScreenTemplate extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final Widget child;
  const ScreenTemplate({
    Key? key,
    required this.title,
    this.actions = const [],
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          SizedBox.expand(
            child: Container(
              // color: Colors.red,
              child: Image.asset(
                'assets/jigsaw.png', repeat: ImageRepeat.repeat,
                // fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 520,
              child: Card(
                margin: EdgeInsets.all(0),
                elevation: 6,
                child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: AppBar(
                    toolbarHeight: 48,
                    elevation: 0,
                    // Here we take the value from the PageHome object that was created by
                    // the App.build method, and use it to set our appbar title.
                    title: FittedBox(child: Text(title)),
                    actions: actions,
                  ),
                  body: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
