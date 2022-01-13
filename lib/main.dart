import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/bloc.dart';
import 'package:scuffed_wordle/screens/screen_home.dart';
import 'package:scuffed_wordle/screens/screen_settings.dart';

void main() {
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
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            // primarySwatch: Colors.teal,
            // primaryColor: Colors.teal[300],
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
          routes: _routes),
    );
  }
}
