import 'package:flutter/material.dart';

class Bubble {
  final double radius;
  final Color color;
  final GestureTapCallback onTap;
  final WidgetBuilder builder;

  Bubble({
    @required this.radius,
    @required this.color,
    this.onTap,
    this.builder,
  });
}
