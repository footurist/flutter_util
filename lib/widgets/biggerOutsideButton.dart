import "package:flutter/material.dart";

class BiggerOutsideButton extends StatelessWidget {
  BiggerOutsideButton({this.child, this.icon, this.padding = 15,
    this.rippleBorderRadius = 10000, this.onTap}
  ): assert((child != null || icon != null) && !(child != null && icon != null));

  final Widget child;
  final Icon icon;
  final double padding;
  final double rippleBorderRadius;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(rippleBorderRadius)
        ),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(padding),
          child: child != null? child: icon,
        ),
      ),
    );
  }
}