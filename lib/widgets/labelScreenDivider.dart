import "package:flutter/material.dart";

class LabelScreenDivider extends StatelessWidget {
  LabelScreenDivider(this.text, this.style);

  final String text;
  final TextStyle style;

  Expanded buildDivider() => Expanded(
    child: Container(
      height: 1,
      color: style.color.withAlpha(255 ~/ 2)
    )
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildDivider(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Text(text, style: style),
        ),
        buildDivider()
      ]
    );
  }
}