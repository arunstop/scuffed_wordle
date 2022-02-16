import 'package:flutter/material.dart';
import 'package:scuffed_wordle/ui.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              value: null,
            ),
          ),
          UiController.vSpace(18),
          Text(
            'Loading game...',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
