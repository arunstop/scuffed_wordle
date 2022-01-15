import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/bloc.dart';
import 'package:scuffed_wordle/screens/screen_home.dart';
import 'package:scuffed_wordle/screens/screen_settings.dart';
import 'package:url_strategy/url_strategy.dart';


void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = 'Scuffed Wordle';
    Map<String, Widget Function(BuildContext)> _routes = {
      '/': (context) => PageHome(title: title),
      '/settings': (context) => const PageSettings(title: 'Settings'),
    };

    return BlocProvider(
      create: (_) => BoardBloc(),
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.teal,
            primaryVariant: Colors.teal[800],
            secondary: Colors.orange,
            secondaryVariant: Colors.orange[800],
          ),
          // brightness: Brightness.light,
        ),
        // darkTheme: ThemeData(
        //   primarySwatch: Colors.red,
        //   primaryColor: Colors.red[300],
        //   // brightness: Brightness.dark,
        // ),
        // home: PageHome(title: title),
        initialRoute: '/',
        routes: _routes,
       
      ),
    );
  }
}
