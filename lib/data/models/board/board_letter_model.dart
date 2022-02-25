import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scuffed_wordle/ui.dart';

part 'board_letter_model.g.dart';

@JsonSerializable()
class BoardLetter {
  final String letter;
  @JsonKey(ignore: true)
  Color? color;
  final String? strColor;

  BoardLetter({required this.letter, required this.strColor}) {
    switch (strColor) {
      case 'pinpoint':
        color = ColorLib.tilePinpoint;
        break;
      case 'okLetter':
        color = ColorLib.tileOkLetter;
        break;
      case 'base':
        color = ColorLib.tileBase;
        break;
      default:
    }
  }

  factory BoardLetter.fromJson(Map<String, dynamic> json) =>
      _$BoardLetterFromJson(json);

  Map<String, dynamic> toJson() => _$BoardLetterToJson(this);

  // @override
  // String toString() {
  //   return 'BoardLetter{letter: $letter, color: $color}';
  // }

}
