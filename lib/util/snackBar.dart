import "package:flutter/material.dart";

class SnackBarUtil {
  static bool _canShow = true;

  static void _tempDisableCanShow(int milliseconds) {
    if (_canShow) {
      _canShow = false;
      Future.delayed(
        Duration(milliseconds: milliseconds + 500),
        () => _canShow = true
      );
    }
  }

  static void show(BuildContext context, String text, [int milliseconds = 1000]) {
    if (_canShow) {
      _tempDisableCanShow(milliseconds);

      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: milliseconds),
          content: Text(
            text,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        )
      );
    }
  }
}