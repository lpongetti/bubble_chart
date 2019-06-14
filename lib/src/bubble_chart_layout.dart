import 'package:bubble_chart/bubble_chart.dart';
import 'package:bubble_chart/src/bubble_layer.dart';
import 'package:bubble_chart/src/bubble_node.dart';
import 'package:flutter/material.dart';

class BubbleChartLayout extends StatelessWidget {
  final BubbleNode root;
  final double Function(BubbleNode) radius;

  BubbleChartLayout({
    @required this.root,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var bubbles = BubbleChart(
          root: root,
          radius: radius,
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );

        return Stack(
          children: bubbles.nodes.fold([], (result, node) {
            return result
              ..add(
                Positioned(
                  top: node.y - node.radius,
                  left: node.x - node.radius,
                  width: node.radius * 2,
                  height: node.radius * 2,
                  child: BubbleLayer(bubble: node),
                ),
              );
          }),
        );
      },
    );
  }
}
