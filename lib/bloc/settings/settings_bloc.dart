import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_states.dart';


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // static final List<Settings> _defaultSettings = [
  //   Settings(
  //     type: SettingsType.darkTheme,
  //     value: false,
  //     title: 'Dark Theme',
  //     icon: const Icon(Icons.dark_mode_rounded),
  //   ),
  //   Settings(
  //     type: SettingsType.highContrast,
  //     value: false,
  //     title: 'High Contrast',
  //     icon: const Icon(Icons.flare_rounded),
  //   ),
  // ];

  static bool _isDarkTheme() {
    Brightness? userTheme = WidgetsBinding.instance?.window.platformBrightness;
    if (userTheme == Brightness.dark) {
      // print('dark');
      return true;
    } // print('light');
    return false;
  }

  SettingsBloc()
      : super(SettingsInit(
          hardMode: false,
          darkTheme: _isDarkTheme(),
          highContrast: false,
        )) {
    // Initialize state
    on<SettingsChange>((event, emit) {
      // print('vwinit');

      // var randomWord = event.list[Random().nextInt(event.list.length)];
      switch (event.type) {
        case SettingsTypes.hardMode:
          emit(state.copyWith(hardMode: event.value));
          break;
        case SettingsTypes.darkTheme:
          emit(state.copyWith(darkTheme: event.value));
          break;
        case SettingsTypes.highContrast:
          emit(state.copyWith(highContrast: event.value));
          break;
        default:
      }
      // print(state.list);
    });

    on<SettingsReset>((event, emit) {
      emit(SettingsInit(
          hardMode: false,
          darkTheme: _isDarkTheme(),
          highContrast: false,
        ));
    });
  }
}
