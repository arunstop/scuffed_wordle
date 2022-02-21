import 'package:equatable/equatable.dart';
import 'package:scuffed_wordle/data/models/settings/settings_model.dart';

class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SettingsChange extends SettingsEvent {
  final SettingsTypes type;
  final dynamic value;

  const SettingsChange({required this.type, required this.value});
}

class SettingsReset extends SettingsEvent {}
class SettingsInitialize extends SettingsEvent {}
