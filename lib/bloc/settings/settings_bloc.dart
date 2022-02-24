import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/settings/settings_events.dart';
import 'package:scuffed_wordle/bloc/settings/settings_states.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';
import 'package:scuffed_wordle/data/repositories/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  static bool _isDarkTheme() {
    Brightness? userTheme = WidgetsBinding.instance?.window.platformBrightness;
    if (userTheme == Brightness.dark) {
      // print('dark');
      return true;
    }
    // print('light');
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
      // print(state.settings.wordLength);
      emit(state.copyWith(
        settings: userLocalSettings,
      ));
      // print(state.settings.wordLength);
    });

    on<SettingsChange>((event, emit) {
      // print('vwinit');

      // var randomWord = event.list[Random().nextInt(event.list.length)];
      // Settings settings = state.settings;
      switch (event.type) {
        case SettingsTypes.hardMode:
          emit(state.copyWith(
            settings: state.settings.copyWith(hardMode: event.value),
          ));
          break;
        case SettingsTypes.darkTheme:
          emit(state.copyWith(
            settings: state.settings.copyWith(darkTheme: event.value),
          ));
          break;
        case SettingsTypes.highContrast:
          emit(state.copyWith(
            settings: state.settings.copyWith(highContrast: event.value),
          ));
          break;
        case SettingsTypes.colorBlindMode:
          emit(state.copyWith(
            settings: state.settings.copyWith(colorBlindMode: event.value),
          ));
          break;
        case SettingsTypes.retypeOnWrongGuess:
          emit(state.copyWith(
            settings: state.settings.copyWith(retypeOnWrongGuess: event.value),
          ));
          break;
        case SettingsTypes.useMobileKeyboard:
          emit(state.copyWith(
            settings: state.settings.copyWith(useMobileKeyboard: event.value),
          ));
          break;
        case SettingsTypes.matrix:
          emit(state.copyWith(
            settings: state.settings.copyWith(matrix: event.value),
          ));
          break;
        default:
      }
      // print("bloc"+jsonEncode(state.settings.toJson()));
      settingsRepo.setLocalSettings(settings: state.settings);
      // print(state.list);
    });

    on<SettingsReset>((event, emit) {
      // emit(SettingsDefault(
      //     settings: Settings().copyWith(
      //   darkTheme: _isDarkTheme(),
      // )));
      emit(SettingsDefault(settings: Settings()));
      settingsRepo.setLocalSettings(settings: state.settings);
    });
  }
}
