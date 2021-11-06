import 'package:bubble_chart/src/bubble_node_base.dart';
import 'package:flutter/material.dart';

class BubbleNode extends BubbleNodeBase {
  List<BubbleNode>? _children;
  BubbleOptions? options;
  int? _padding;
  num? _staticValue;
  WidgetBuilder? _builder;
  BubbleNode? _parent;
  double? radius;
  double? x = 0;
  double? y = 0;

  int? get padding => _padding;
  WidgetBuilder? get builder => _builder;
  BubbleNode? get parent => _parent;

  BubbleNode.node({
    required List<BubbleNode> children,
    int padding = 0,
    this.options,
  }): assert(children.length > 0) {
    this._children = children;
    this._padding = padding;
  }


  List<BubbleNode> get children {
    return this._children?.map((e) { e._parent = this; return e;}).toList() ?? [];
  }

  num get value {
    if (_staticValue != null) { return _staticValue!; }
    num value = 0;
    for (var child in _children!) {
      value += child.value;
    }
    return value;
  }

  set value(num value) {
    this._staticValue = value;
  }

  BubbleNode.leaf({
    required num value,
    WidgetBuilder? builder,
    this.options,
  })  : _staticValue = value,
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
    for (var child in children) {
      if (child.children.isEmpty) {
        leafs.add(child);
      } else {
        leafs.addAll(child.leaves);
      }
    }
    return leafs;
  }

  List<BubbleNode> get nodes {
    var nodes = <BubbleNode>[];
    for (var child in children) {
      nodes.add(child);
      if (child.children.isNotEmpty)
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
      if (children.isNotEmpty) {
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
      if (children.isNotEmpty) {
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
