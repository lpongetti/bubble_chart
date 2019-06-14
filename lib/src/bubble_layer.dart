import 'package:bubble_chart/src/bubble_node.dart';
import 'package:flutter/material.dart';

class BubbleLayer extends StatelessWidget {
  final BubbleNode bubble;

  const BubbleLayer({this.bubble});

  onTap() {
    if (bubble.options.onTap != null) bubble.options.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InkResponse(
        child: Container(
          width: bubble.radius * 2,
          height: bubble.radius * 2,
          decoration: BoxDecoration(
            border: bubble.options?.border ?? Border(),
            color: bubble.options?.color ?? Theme.of(context).accentColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: bubble.options?.child ?? Container(),
          ),
        ),
      ),
    );
  }
}
