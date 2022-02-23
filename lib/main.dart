import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_bloc.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_events.dart';
import 'package:scuffed_wordle/bloc/dictionary/dictionary_states.dart';
import 'package:scuffed_wordle/bloc/settings/settings_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_states.dart';
import 'package:scuffed_wordle/data/models/dictionary/dictionary_model.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/repositories/settings_repository.dart';
import 'package:scuffed_wordle/data/services/board_service.dart';
import 'package:scuffed_wordle/data/services/dictionary_service.dart';
import 'package:scuffed_wordle/data/services/settings_service.dart';
import 'package:scuffed_wordle/screens/howtoplay_screen.dart';
import 'package:scuffed_wordle/screens/screen_home.dart';
import 'package:scuffed_wordle/screens/settings_screen.dart';
import 'package:scuffed_wordle/ui.dart';
import 'package:scuffed_wordle/widgets/widget_confetti.dart';
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
    // void _dictionaryBlocListener(BuildContext context, DictionaryState state) {
    //   context.read<BoardBloc>().add(
    //         BoardInitialize(
    //           length: 5,
    //           lives: 6,
    //         ),
    //       );
    // }

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SettingsRepo _settingsRepo = SettingsService(prefs: _prefs);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsBloc(
            settingsRepo: _settingsRepo,
          )..add(SettingsInitialize()),
        ),
        BlocProvider(
          create: (context) => DictionaryBloc(
            dictionaryRepo: DictionaryService(prefs: _prefs),
            settingsRepo: _settingsRepo,
          )..add(DictionaryInitialize()),
        ),
        BlocProvider(
            create: (context) => BoardBloc(
                  boardRepo: BoardService(prefs: _prefs),
                  // dictionaryBloc: BlocProvider.of<DictionaryBloc>(context),
                  // settingsBloc: BlocProvider.of<SettingsBloc>(context),
                  dictionaryRepo: DictionaryService(prefs: _prefs),
                  settingsRepo: _settingsRepo,
                )..add(BoardInitialize())),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          print('board');
          return MaterialApp(
            title: "Scuffed Wordle - A word guessing game",
            theme: ScuffedWordleTheme.light,
            darkTheme: ScuffedWordleTheme.dark,
            themeMode: settingsState.settings.darkTheme
                ? ThemeMode.dark
                : ThemeMode.light,
            // home: PageHome(title: title),
            initialRoute: '/',
            routes: _routes,
            builder: (context, child) => OKToast(child: ConfettiLayout(child: child!)),
          );
        },
      ),
    );
  }
}

class ScuffedWordleTheme {
  static ThemeData get light => ThemeData(
        fontFamily: 'RobotoMono',
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
        colorScheme: const ColorScheme.light(
          primary: Colors.teal,
          primaryVariant: Colors.teal,
          secondary: Colors.orange,
          secondaryVariant: Colors.orange,
        ),
      );

  static ThemeData get dark => ThemeData(
        fontFamily: 'RobotoMono',
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
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
      );
}
