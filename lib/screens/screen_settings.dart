import 'package:flutter/material.dart';
import 'package:scuffed_wordle/widgets/widget_screen_template.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _PageSettingsState createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  @override
  Widget build(BuildContext context) {
    return ScreenTemplate(title: widget.title, child: const Text('SETTINGS'));
  }
}
