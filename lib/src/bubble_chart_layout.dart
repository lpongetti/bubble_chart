import 'package:bubble_chart/bubble_chart.dart';
import 'package:bubble_chart/src/bubble_layer.dart';
import 'package:flutter/material.dart';

class BubbleChartLayout extends StatelessWidget {
  final List<BubbleNode> children;
  final double Function(BubbleNode)? radius;
  final Duration? duration;
  // Stretch factor determines the width:height ratio of the chart
  final double stretchFactor;

  const BubbleChartLayout({
    super.key,
    required this.children,
    this.radius,
    this.duration,
    this.stretchFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var bubbles = BubbleChart(
          root: BubbleNode.node(children: children),
          radius: radius,
          size: Size(constraints.maxWidth, constraints.maxHeight),
          stretchFactor: stretchFactor,
        );

        return Stack(
          children: bubbles.nodes.fold([], (result, node) {
            return result
              ..add(
                duration == null
                    ? Positioned(
                        key: node.key,
                        top: node.y! - node.radius!,
                        left: node.x! - node.radius!,
                        width: node.radius! * 2,
                        height: node.radius! * 2,
                        child: BubbleLayer(bubble: node),
                      )
                    : AnimatedPositioned(
                        key: node.key,
                        top: node.y! - node.radius!,
                        left: node.x! - node.radius!,
                        width: node.radius! * 2,
                        height: node.radius! * 2,
                        duration: duration ?? const Duration(milliseconds: 300),
                        child: BubbleLayer(bubble: node),
                      ),
              );
          }),
        );
      },
    );
  }
}
