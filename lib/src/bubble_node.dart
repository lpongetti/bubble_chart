import 'dart:math';
import 'package:bubble_chart/src/bubble.dart';
import 'package:bubble_chart/src/quadtree.dart';
import 'package:flutter/material.dart';

class BubbleNode implements Bubble, HasPoint {
  final Bubble bubble;
  Point point;

  BubbleNode({
    this.bubble,
    Point point,
  }) : this.point = point;

  @override
  get builder => bubble.builder;

  @override
  Color get color => bubble.color;

  @override
  get onTap => bubble.onTap;

  @override
  double get radius => bubble.radius;
}
