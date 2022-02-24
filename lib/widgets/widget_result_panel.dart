import 'package:flutter/material.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/ui.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = context.read<BoardBloc>();

    return Align(
      alignment: Alignment.center,
      child: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(12, 18, 12, 24),
          color: boardBloc.state.win == true ? ColorList.ok : ColorList.error,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GAME OVER',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.white,
                      fontFamily: 'Rubik',
                    ),
              ),
              UiLib.vSpace(18),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              boardBloc.add(BoardRestart());
                            },
                            child: Icon(Icons.share_rounded),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          UiLib.vSpace(12),
                          Text('Share Result'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              boardBloc.add(BoardRestart());
                            },
                            child: Icon(Icons.replay_rounded),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          UiLib.vSpace(12),
                          Text(
                            'Play Again',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              boardBloc.add(BoardRestart());
                            },
                            child: Icon(Icons.close_rounded),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          UiLib.vSpace(12),
                          Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
