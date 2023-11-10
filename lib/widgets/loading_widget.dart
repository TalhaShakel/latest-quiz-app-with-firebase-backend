import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingIndicatorWidget extends StatelessWidget {

  final Color? color;
  const LoadingIndicatorWidget({
    Key? key, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width: 60,
          height: 60,
          child: LoadingIndicator(
            colors: [color ?? Theme.of(context).primaryColor],
            indicatorType: Indicator.ballBeat,
          )),
    );
  }
}
