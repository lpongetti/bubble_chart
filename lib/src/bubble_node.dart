import 'package:bubble_chart/src/bubble_node_base.dart';
import 'package:flutter/material.dart';

class BubbleNode extends BubbleNodeBase {
  Key? key;
  num _value = 0;
  List<BubbleNode>? children;
  BubbleOptions? options;
  int? padding;
  WidgetBuilder? builder;
  BubbleNode? parent;

  num get value {
    if (children == null) {
      return _value;
    }
    return children!.fold(0, (a, b) => a + b.value);
  }

  set value(num newValue) {
    if (children == null) {
      _value = newValue;
    }
  }

  BubbleNode.node({
    required this.children,
    this.padding = 0,
    this.options,
  }) : assert(children != null && children.isNotEmpty) {
    for (var child in children!) {
      _value += child.value;
      child.parent = this;
    }
  }

  BubbleNode.leaf({
    required num value,
    this.key,
    this.builder,
    this.options,
  }) : _value = value;

  int get depth {
    int depth = 0;
    BubbleNode? dparent = parent;
    while (dparent != null) {
      dparent = dparent.parent;
      depth++;
    }
    return depth;
  }

  List<BubbleNode> get leaves {
    var leaves = <BubbleNode>[];
    for (var child in children!) {
      if (child.children == null) {
        leaves.add(child);
      } else {
        leaves.addAll([child, ...child.leaves]);
      }
    }
    return leaves;
  }

  List<BubbleNode> get nodes {
    var nodes = <BubbleNode>[];
    for (var child in children!) {
      nodes.add(child);
      if (child.children != null) nodes.addAll(child.nodes);
    }
    return nodes;
  }

  eachBefore(Function(BubbleNode) callback) {
    BubbleNode node = this;
    var nodes = [node];

    while (nodes.isNotEmpty) {
      node = nodes.removeLast();
      callback(node);
      var children = node.children;
      if (children != null) {
        nodes.addAll(children.reversed);
      }
    }
  }

  eachAfter(Function(BubbleNode) callback) {
    BubbleNode node = this;
    var nodes = [node];
    var next = [];

    while (nodes.isNotEmpty) {
      node = nodes.removeLast();
      next.add(node);
      var children = node.children;
      if (children != null) {
        nodes.addAll(children);
      }
    }

    while (next.isNotEmpty && (node = next.removeLast()) != null) {
      callback(node);
    }
  }
}

class BubbleOptions {
  final Color? color;
  final BoxBorder? border;
  final Widget? child;
  GestureTapCallback? onTap;

  BubbleOptions({
    this.color,
    this.border,
    this.child,
    this.onTap,
  });
}
