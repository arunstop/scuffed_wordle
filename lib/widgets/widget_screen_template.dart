import 'package:flutter/material.dart';

class ScreenTemplate extends StatelessWidget {
  final String title;
  final Widget child;
  const ScreenTemplate({Key? key, required this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _doNavigate() {
      Navigator.pushNamed(context, '/settings');
    }

    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
            child: SizedBox(
                width: 520,
                child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 6,
                    child: Scaffold(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      appBar: AppBar(
                        toolbarHeight: 48,
                        elevation: 0,
                        // Here we take the value from the PageHome object that was created by
                        // the App.build method, and use it to set our appbar title.
                        title: Text(title),
                        actions: [
                          IconButton(
                            onPressed: () => _doNavigate(),
                            icon: const Icon(Icons.settings),
                          ),
                        ],
                      ),
                      body: child,
                    ),),),),);
  }
}
