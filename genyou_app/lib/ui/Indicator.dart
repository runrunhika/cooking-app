import 'package:flutter/material.dart';

enum IndicatorType {
  Circle,
  Linear
}

class MyIndicator {
  static showIndicator(BuildContext context, IndicatorType type) {
    Widget child = type == IndicatorType.Circle? CircularProgressIndicator() : LinearProgressIndicator();

    showGeneralDialog(
        context: context,
        barrierDismissible: false,
//        transitionDuration: Duration(milliseconds: 3),
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, Animation animation, Animation secondaryAnimation) {
          return Center(
            child: child
          );
        }
    );
  }
}