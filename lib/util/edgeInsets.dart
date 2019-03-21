import "package:flutter/material.dart";

class EdgeInsetsUtil {
  static double getHighest(EdgeInsets edgeInsets) {
    var values = [edgeInsets.top, edgeInsets.left, edgeInsets.bottom, edgeInsets.right];

    values.sort();

    return values.last;
  }

  static List<Widget> interspersed(List<Widget> widgets, double padding,
    {String mode = "vertical", bool last = false}
  ) {
    var newWidgets = <Widget>[];
    var pad = mode == "vertical"? Container(height: padding): Container(width: padding);

    widgets.forEach((w) => newWidgets.addAll([w, pad]));
    if (!last) newWidgets.removeLast();

    return newWidgets;
  }
}