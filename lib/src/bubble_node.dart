import 'package:bubble_chart/src/bubble_node_base.dart';
import 'package:flutter/material.dart';

class BubbleNode extends BubbleNodeBase {
  List<BubbleNode>? _children;
  BubbleOptions? options;
  int? _padding;
  num? _value;
  WidgetBuilder? _builder;
  BubbleNode? _parent;
  double? radius;
  double? x = 0;
  double? y = 0;

  List<BubbleNode>? get children => _children;
  num? get value => _value;
  int? get padding => _padding;
  WidgetBuilder? get builder => _builder;
  BubbleNode? get parent => _parent;

  BubbleNode.node({
    required List<BubbleNode> children,
    int padding = 0,
    this.options,
  })  : _children = children,
        _padding = padding,
        assert(children.length > 0) {
    _value = 0;
    for (var child in children) {
      _value = _value! + child.value!;
      child._parent = this;
    }
  }

  BubbleNode.leaf({
    required num value,
    WidgetBuilder? builder,
    this.options,
  })  : _value = value,
        _builder = builder;

  int get depth {
    int depth = 0;
    BubbleNode? parent = _parent;
    while (parent != null) {
      parent = parent._parent;
      depth++;
    }
    return depth;
  }

  List<BubbleNode> get leaves {
    var leafs = <BubbleNode>[];
    for (var child in children!) {
      if (child.children == null) {
        leafs.add(child);
      } else {
        leafs.addAll(child.leaves);
      }
    }
    return leafs;
  }

  List<BubbleNode> get nodes {
    var nodes = <BubbleNode>[];
    for (var child in children!) {
      nodes.add(child);
      if (child.children != null && child.children!.isNotEmpty)
        nodes.addAll(child.nodes);
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
  final GestureTapCallback? onTap;

  BubbleOptions({
    this.color,
    this.border,
    this.child,
    this.onTap,
  });
}
