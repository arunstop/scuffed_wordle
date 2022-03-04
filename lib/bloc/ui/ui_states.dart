import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:scuffed_wordle/data/stt.dart';

class UiState extends Equatable {
  Stt stt;
  UiState({
    required this.stt,
  });

  @override
  List<Object> get props => [stt];

  UiState copyWith({
    Stt? stt,
  }) {
    return UiState(
      stt: stt ?? this.stt,
    );
  }

  @override
  String toString() => 'UiState(stt: $stt)';
}

class UiInitial extends UiState {
  UiInitial()
      : super(
          stt: Stt(
          ),
        );
}
