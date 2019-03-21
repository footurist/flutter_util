import "dart:async";

import "package:flutter/material.dart";

/// (Automatically) cross-fades between [children] in both directions.
class WidgetFader extends StatefulWidget {
  WidgetFader({
    @required List<Widget> children,
    this.fadeDuration = 750,
    this.pauseDuration = 750,
    this.reverse = false,
    this.auto = true
  }):
    this.children = children,
    this._maxIndex = children.length - 1;

  final List<Widget> children;
  final int fadeDuration;
  final int pauseDuration;
  final bool reverse;
  final bool auto;
  final int _maxIndex;
  
  @override
  State<StatefulWidget> createState() {
    return _WidgetFaderState();
  }
}

class _WidgetFaderState extends State<WidgetFader> with TickerProviderStateMixin {
  List<AnimationController> _controllers;
  List<Animation> _animations;
  List<StreamSubscription> _subscriptions = List(2);

  void initState() { 
    super.initState();

    _init();

    if (widget.auto) _play(0);
  }
  
  void _init() {
    _controllers = List.generate(
      widget.children.length,
      (i) => AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.fadeDuration)
      )
    );
    _animations = List.generate(
      widget.children.length,
      (i) => Tween(begin: 0.0, end: 1.0).animate(_controllers[i])
    );
  }

  int _calcToBeFadedIn(int i) {
    int toBeFadedIn;

    if (widget.reverse) {
      toBeFadedIn = i - 1;

      if (toBeFadedIn < 0) toBeFadedIn = widget._maxIndex;
    } else {
      toBeFadedIn = i + 1;
      
      if (toBeFadedIn > widget._maxIndex) toBeFadedIn = 0;
    }

    return toBeFadedIn;
  }

  void _play(int i) {
    int toBeFadedIn;
    
    if (i > widget._maxIndex) i = 0;
    else if (i < 0) i = widget._maxIndex;
    
    toBeFadedIn = _calcToBeFadedIn(i);
    _controllers[i].value = 1.0;
    _subscriptions[0] = _controllers[i].reverse().asStream().listen(
      (v) {
        if (widget.auto) {
          _subscriptions[1] = Future.delayed(
            Duration(milliseconds: widget.pauseDuration),
          ).asStream().listen((v) => _play(toBeFadedIn));
        }
      }
    );
    _controllers[toBeFadedIn].forward();
  }

  List<Widget> _buildChildren() => List.generate(
    3, (i) => FadeTransition(
      opacity: _animations[i],
      child: widget.children[i],
    )
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: _buildChildren(),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((c) => c.dispose());
    _subscriptions?.forEach((s) => s.cancel());

    super.dispose();
  }
}