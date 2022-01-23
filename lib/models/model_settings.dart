import 'package:flutter/material.dart';

enum SettingsType { darkTheme, highContrast }

class Settings {
  final SettingsType type;
  final String title;
  final bool value;
  final Icon icon;

  Settings({
    required this.type,
    required this.title,
    required this.value,
    required this.icon,
  });
}
