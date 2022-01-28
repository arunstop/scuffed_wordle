import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scuffed_wordle/ui.dart';

part 'model_board_letter.g.dart';

@JsonSerializable()
class BoardLetter {
  final String letter;
  @JsonKey(ignore: true)
  Color? color;
  final String? strColor;

  BoardLetter({required this.letter, required this.strColor}) {
    switch (strColor) {
      case 'pinpoint':
        color = BoardColors.pinpoint;
        break;
      case 'okLetter':
        color = BoardColors.okLetter;
        break;
      case 'base':
        color = BoardColors.base;
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
