import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_states.dart';
import 'package:scuffed_wordle/data/models/model_settings.dart';
import 'package:scuffed_wordle/data/repositories/settings_repostiory.dart';

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

  final SettingsRepo settingsRepo;

  SettingsBloc({required this.settingsRepo})
      : super(SettingsDefault(
          settings: Settings(darkTheme: _isDarkTheme()),
        )) {
    // Initialize state
    on<SettingsInitialize>((event, emit) async {
      Settings userLocalSettings = await settingsRepo.getLocalSettings();
      // Check If user has changed the settings
      // by comparing it to default value
      if (userLocalSettings == Settings()) {
        return;
      }
      // changed
      emit(SettingsDefault(
        settings: userLocalSettings,
      ));
    });

    on<SettingsChange>((event, emit) {
      // print('vwinit');

      // var randomWord = event.list[Random().nextInt(event.list.length)];
      switch (event.type) {
        case SettingsTypes.hardMode:
          emit(state.copyWith(
              settings: state.settings.copyWith(hardMode: event.value)));
          break;
        case SettingsTypes.darkTheme:
          emit(state.copyWith(
              settings: state.settings.copyWith(darkTheme: event.value)));
          break;
        case SettingsTypes.highContrast:
          emit(state.copyWith(
              settings: state.settings.copyWith(highContrast: event.value)));
          break;
        case SettingsTypes.colorBlindMode:
          emit(state.copyWith(
              settings: state.settings.copyWith(colorBlindMode: event.value)));
          break;
        default:
      }
      settingsRepo.setLocalSettings(settings: state.settings);
      // print(state.list);
    });

    on<SettingsReset>((event, emit) {
      emit(SettingsDefault(
          settings: Settings().copyWith(
        darkTheme: _isDarkTheme(),
      )));
      settingsRepo.setLocalSettings(settings: state.settings);
    });
  }
}
