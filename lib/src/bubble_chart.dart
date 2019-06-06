import 'dart:math';
import 'package:bubble_chart/src/bubble.dart';
import 'package:bubble_chart/src/bubble_layer.dart';
import 'package:bubble_chart/src/bubble_node.dart';
import 'package:bubble_chart/src/quadtree.dart';
import 'package:flutter/material.dart';

class BubbleChart extends StatelessWidget {
  final List<Bubble> bubbles;
  final int padding;

  BubbleChart({
    Key key,
    @required this.bubbles,
    this.padding = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BubbleChartContainer(
          bubbles: bubbles,
          padding: padding,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        );
      },
    );
  }
}

class BubbleChartContainer extends StatelessWidget {
  final List<Bubble> bubbles;
  final int padding;
  final double width;
  final double height;

  BubbleChartContainer({
    @required this.bubbles,
    @required this.width,
    @required this.height,
    this.padding = 2,
  });

  List<BubbleNode> _computeBubbles() {
    var halfWidth = width / 2;
    var halfHeight = height / 2;

    var nodes = bubbles.map((bubble) {
      var x = Random().nextDouble() * halfWidth,
          y = Random().nextDouble() * halfHeight;

      return BubbleNode(bubble: bubble, point: Point(x, y));
    }).toList();

    var data = List<BubbleNode>()..addAll(nodes);

    var alpha = 0.1;
    while ((alpha *= 0.99) > 0.005) {
      for (var d in data)
        d.point = Point(d.point.x + ((halfWidth - d.point.x) * alpha),
            d.point.y + ((halfHeight - d.point.y) * alpha));

      collide(nodes, data, 0.5);
    }

    return nodes;
  }

  collide(List<BubbleNode> nodes, List<BubbleNode> data, double alpha) {
    for (var node in nodes) {
      final quadtree =
          QuadTree(data, new Rectangle(0, 0, width * 2, height * 2), 0, 0);
      quadtree.visit((quad) {
        if (quad.node != null && quad.node != node) {
          var x = node.point.x - quad.node.point.x,
              y = node.point.y - quad.node.point.y,
              l = sqrt(x * x + y * y),
              r = node.radius + quad.node.radius + padding;
          if (l < r) {
            l = (l - r) / l * alpha;
            x *= l;
            y *= l;
            node.point = Point(node.point.x - x, node.point.y - y);
            quad.node.point =
                Point(quad.node.point.x + x, quad.node.point.y + y);
          }
        }
      });
    }
  }

  List<Widget> _buildBubbles() {
    var nodes = _computeBubbles();

    return nodes.map((node) {
      return Positioned(
        child: BubbleLayer(node),
        top: node.point.y.toDouble() - node.radius,
        left: node.point.x.toDouble() - node.radius,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: _buildBubbles(),
      ),
    );
  }
}
