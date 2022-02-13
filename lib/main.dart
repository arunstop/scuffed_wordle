import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_states.dart';
import 'package:scuffed_wordle/data/services/board_service.dart';
import 'package:scuffed_wordle/data/services/dictionary_service.dart';
import 'package:scuffed_wordle/data/services/settings_service.dart';
import 'package:scuffed_wordle/screens/howtoplay_screen.dart';
import 'package:scuffed_wordle/screens/screen_home.dart';
import 'package:scuffed_wordle/screens/settings_screen.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  // Remove '#' dangle on url
  setPathUrlStrategy();
  runApp(const ScuffedWordleApp());
}

class ScuffedWordleApp extends StatelessWidget {
  const ScuffedWordleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String title = 'Scuffed Wordle';
    Map<String, Widget Function(BuildContext)> _routes = {
      '/': (context) => HomeScreen(title: title),
      '/settings': (context) => const SettingsScreen(title: 'Settings'),
      '/howtoplay': (context) => const HowToPlayScreen(title: 'How To Play'),
    };

    // final userTheme = WidgetsBinding.instance?.window.platformBrightness;
    // if(userTheme == Brightness.dark){
    //   print('dark');
    // }else{
    //   print('light');
    // }
    void _dictionaryBlocListener(BuildContext context, DictionaryState state) {
      context.read<BoardBloc>().add(BoardInitialize());
    }

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DictionaryBloc(
            dictionaryRepo: DictionaryService(prefs: _prefs),
          ),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(
            settingsRepo: SettingsService(prefs: _prefs),
          ),
        ),
        BlocProvider(
          create: (context) => BoardBloc(
            boardRepo: BoardService(prefs: _prefs),
            dictionaryBloc: BlocProvider.of<DictionaryBloc>(context),
            settingsBloc: BlocProvider.of<SettingsBloc>(context),
          ),
        ),
      ],
      child: BlocListener<DictionaryBloc, DictionaryState>(
        listener: _dictionaryBlocListener,
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) => MaterialApp(
            title: "Scuffed Wordle - A word guessing game",
            theme: ThemeData(
              brightness: Brightness.light,
              // primaryColor: Colors.teal,
              // primaryColorDark: Colors.teal,
              // primarySwatch: Colors.teal,
              scaffoldBackgroundColor: Colors.grey[50],
              // colorScheme: ColorScheme.fromSwatch().copyWith(
              //   primary: Colors.teal,
              //   primaryVariant: Colors.teal[800],
              //   secondary: Colors.orange,
              //   secondaryVariant: Colors.orange[800],
              // ),
              colorScheme: ColorScheme.light(
                primary: Colors.teal,
                primaryVariant: Colors.teal,
                secondary: Colors.orange,
                secondaryVariant: Colors.orange,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.dark(
                primary: Colors.teal,
              ),
              // primaryColorDark: Colors.teal[300],
              // primarySwatch: Colors.teal,
              // scaffoldBackgroundColor: Colors.grey[50],
              // primaryColor: Colors.teal,
              // primaryColorDark: Colors.teal,
              // primarySwatch: Colors.teal,
              // colorScheme: ColorScheme.light(
              //   // primary: Colors.teal,
              //   // primaryVariant: Colors.teal[800],
              //   // secondary: Colors.orange,
              //   // secondaryVariant: Colors.orange[800],
              // ),
            ),
            themeMode: state.settings.darkTheme ? ThemeMode.dark : ThemeMode.light,
            // home: PageHome(title: title),
            initialRoute: '/',
            routes: _routes,
          ),
        ),
      ),
    );
  }
}
