import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';

class ConfettiLayout extends StatefulWidget {
  final Widget child;
  const ConfettiLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<ConfettiLayout> createState() => _ConfettiLayoutState();
}

class _ConfettiLayoutState extends State<ConfettiLayout> {
  late ConfettiController _controller;

  static final double left = pi;
  static final double top = -pi / 2;
  static final double right = 0;
  static final double bottom = pi / 2;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(milliseconds: 1));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BoardBloc, BoardState>(
      listener: (context, state) {
        if (state is BoardGameOver && state.win == true) {
          _controller.play();
        } else {
          _controller.stop();
        }
      },
      child: Stack(
        children: [
          widget.child,
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.yellow,
                Colors.green,
                Colors.purple,
                Colors.orange
              ],
              // shouldLoop: true,
              blastDirectionality: BlastDirectionality.explosive,
              // blastDirection: top,
              emissionFrequency: 0.3,
              numberOfParticles: 18,
              gravity: 0.18,
              // minBlastForce: 24,
              // maxBlastForce: 60,
            ),
          ),
        ],
      ),
    );
  }
}
