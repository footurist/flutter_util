import "package:flutter/material.dart";

class RoutesUtil {
  static void popTimes(int times, BuildContext context) {
    for (var i = 0; i < times; i++) {
      Navigator.pop(context);
    }
  }

  static SlideTransition _transparentMaterialPageRouteSlideTransition(
    Animation<double> animation, Widget child
  ) => SlideTransition(
    position: Tween(begin: Offset(0, 0.135), end: Offset(0, 0)).animate(
      CurvedAnimation(
        curve: Curves.easeOut,
        parent: animation
      )
    ),
    child: child,
  );

  static PageRouteBuilder transparentMaterialPageRoute(Widget child) => PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, _) => FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          curve: Curves.easeOut,
          parent: animation
        ),
      ),
      child: _transparentMaterialPageRouteSlideTransition(animation, child),
    )
  );
}