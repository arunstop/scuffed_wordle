import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scuffed_wordle/ui.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SpinKitDoubleBounce(
          //   size: 90,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          // SpinKitChasingDots(
          //   size: 90,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          // SpinKitRotatingCircle(
          //   size: 90,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          // SpinKitSpinningLines(
          //   size: 90,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          // SpinKitPulse(
          //   size: 90,
          //   color: Theme.of(context).colorScheme.primary,
          // ),
          SpinKitSquareCircle(
            size: 120,
            color: Theme.of(context).colorScheme.primary,
          ),
          UiLib.vSpace(24),
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
