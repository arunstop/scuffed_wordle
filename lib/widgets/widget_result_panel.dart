import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scuffed_wordle/bloc/board/board_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scuffed_wordle/ui.dart';

class ResultPanel extends StatefulWidget {
  const ResultPanel({Key? key}) : super(key: key);

  @override
  State<ResultPanel> createState() => _ResultPanelState();
}

class _ResultPanelState extends State<ResultPanel> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    BoardBloc boardBloc = context.read<BoardBloc>();

    Widget _getFab({
      required String label,
      required Icon icon,
      required Function action,
    }) =>
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FloatingActionButton(
                onPressed: () {
                  action();
                },
                child: icon,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              UiLib.vSpace(12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );

    Widget _panelWidget = Container(
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
              _getFab(
                label: 'Share Result',
                icon: Icon(Icons.share_rounded),
                action: () {
                  boardBloc.add(BoardRestart());
                },
              ),
              _getFab(
                label: 'Play again',
                icon: Icon(Icons.replay_rounded),
                action: () {
                  boardBloc.add(BoardRestart());
                },
              ),
              _getFab(
                label: 'Define',
                icon: Icon(Icons.search_rounded),
                action: () {
                  setState(() {
                    _show = false;
                  });
                },
              ),
              _getFab(
                label: 'Close',
                icon: Icon(Icons.close_rounded),
                action: () {
                  setState(() {
                    _show = false;
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
    return Builder(
      builder: (context) {
        return Align(
          alignment: _show ? Alignment.center : Alignment.bottomCenter,
          child: _show == true
              ? _panelWidget
              : Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _show = true;
                      });
                    },
                    child: Icon(Icons.keyboard_arrow_up_rounded),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
        );
      }
    );
  }
}
