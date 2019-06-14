import 'package:bubble_chart/src/bubble_node.dart';
import 'package:flutter/material.dart';

class BubbleLayer extends StatelessWidget {
  final BubbleNode bubble;

  const BubbleLayer({this.bubble});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: bubble.onTap,
      child: InkResponse(
        child: Container(
          width: bubble.radius * 2,
          height: bubble.radius * 2,
          decoration: BoxDecoration(
            color: bubble.color ?? Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child:
                bubble.builder != null ? bubble.builder(context) : Container(),
          ),
        ),
      ),
    );
  }
}
