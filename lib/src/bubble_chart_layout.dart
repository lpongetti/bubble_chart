import 'package:bubble_chart/bubble_chart.dart';
import 'package:bubble_chart/src/bubble_layer.dart';
import 'package:flutter/material.dart';

class BubbleChartLayout extends StatelessWidget {
  final List<BubbleNode> children;
  final double Function(BubbleNode)? radius;
  final Duration? duration;
  final int padding;

  BubbleChartLayout({
    required this.children,
    this.radius,
    this.duration,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var bubbles = BubbleChart(
          root: BubbleNode.node(children: children, padding: this.padding),
          radius: radius,
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );

        return Stack(
          children: bubbles.nodes.fold([], (result, node) {
            return result
              ..add(
                duration == null
                    ? Positioned(
                        top: node.y! - node.radius!,
                        left: node.x! - node.radius!,
                        width: node.radius! * 2,
                        height: node.radius! * 2,
                        child: BubbleLayer(bubble: node),
                      )
                    : AnimatedPositioned(
                        top: node.y! - node.radius!,
                        left: node.x! - node.radius!,
                        width: node.radius! * 2,
                        height: node.radius! * 2,
                        duration: duration ?? Duration(milliseconds: 300),
                        child: BubbleLayer(bubble: node),
                      ),
              );
          }),
        );
      },
    );
  }
}
