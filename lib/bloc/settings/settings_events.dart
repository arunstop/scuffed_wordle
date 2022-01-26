import 'package:equatable/equatable.dart';
import 'package:scuffed_wordle/bloc/settings/settings_states.dart';

class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsChange extends SettingsEvent {
  final SettingsTypes type;
  final bool value;

  const SettingsChange({required this.type, required this.value});
}

class SettingsReset extends SettingsEvent {}