import 'dart:math';

import 'package:bubble_chart/src/bubble_node.dart';
import 'package:bubble_chart/src/bubble_node_base.dart';
import 'package:flutter/material.dart';

class BubbleChart {
  final BubbleNode root;
  final Size size;
  final double Function(BubbleNode)? radius;
  // Stretch factor determines the width:height ratio of the chart
  final double stretchFactor;

  List<BubbleNode> get leaves {
    return root.leaves;
  }

  List<BubbleNode> get nodes {
    return root.nodes;
  }

  BubbleChart({
    required this.root,
    required this.size,
    this.radius,
    this.stretchFactor = 1.0,
  })  : assert(root.children != null && root.children!.length > 0),
        assert(size.width > 0 && size.height > 0) {
    root.x = size.width / 2;
    root.y = size.height / 2;

    if (root.children != null) {
      root..leaves.forEach(_radiusLeaf(_defaultRadius));
      _packEnclose(root.children!);
      print(root.children);
      _translateAndScale(root.children!);
      print(root.children);
    }

    // if (radius != null) {
    //   root
    //     ..leaves.forEach(_radiusLeaf(radius))
    //     ..eachAfter(_packChildren(0.5))
    //     ..eachBefore(_translateChild(1));
    // } else {
    //   root
    //     ..leaves.forEach(_radiusLeaf(_defaultRadius))
    //     ..eachAfter(_packChildren(1, 0))
    //     ..eachAfter(_packChildren(root.radius! / min(size.width, size.height)))
    //     ..eachBefore(
    //         _translateChild(min(size.width, size.height) / (2 * root.radius!)));
    // }
  }

  _translateAndScale(List<BubbleNode> circles) {
    double xmin = double.infinity;
    double xmax = -double.infinity;
    double ymin = double.infinity;
    double ymax = -double.infinity;

    circles.forEach((circle) {
      final left = circle.x! - circle.radius!;
      final right = circle.x! + circle.radius!;
      final top = circle.y! - circle.radius!;
      final bottom = circle.y! + circle.radius!;

      if (left < xmin) {
        xmin = left;
      }
      if (right > xmax) {
        xmax = right;
      }
      if (top < ymin) {
        ymin = top;
      }
      if (bottom > ymax) {
        ymax = bottom;
      }
    });

    final scaleX = size.width / (xmax - xmin);
    final scaleY = size.height / (ymax - ymin);

    final scale = min(scaleX, scaleY);

    // Calculate the extra space after scaling.
    // TODO: Make this for vertical and horizontal
    double extraSpace = size.width - (xmax - xmin) * scale;

    for (final circle in circles) {
      // Translate, scale the x and y coordinates, and center align.
      circle.x = (circle.x! - xmin) * scale + extraSpace / 2;
      circle.y = (circle.y! - ymin) * scale;

      // Scale the radius.
      circle.radius = circle.radius! * scale;
    }
  }

  Function(BubbleNode) _radiusLeaf(double Function(BubbleNode)? radius) {
    return (BubbleNode node) {
      if (node.children == null) {
        node.radius = max(0, radius!(node));
      }
    };
  }

  double _defaultRadius(BubbleNode node) {
    return sqrt(node.value);
  }

  _packChildren(double k, [int? padding]) {
    return (BubbleNode node) {
      var children = node.children;
      if (children != null) {
        var r = (padding ?? node.padding)! * k;

        if (r != 0) {
          for (var child in children) child.radius = child.radius! + r;
        }
        var e = _packEnclose(children)!;
        if (r != 0) {
          for (var child in children) child.radius = child.radius! - r;
        }
        node.radius = e + r;
      }
    };
  }

  _translateChild(double k) {
    return (BubbleNode node) {
      var parent = node.parent;
      node.radius = node.radius! * k;
      if (parent != null) {
        node.x = parent.x! + k * node.x!;
        node.y = parent.y! + k * node.y!;
      }
    };
  }

  double? _packEnclose(List<BubbleNode> circles) {
    if (circles.length == 0) return 0;

    // Place the first circle.
    var first = circles[0];
    first
      ..x = 0
      ..y = 0;
    if (circles.length == 1) return first.radius;

    // Place the second circle.
    var second = circles[1];
    first.x = -second.radius!;
    second
      ..x = first.radius
      ..y = 0;
    if (circles.length == 2) return first.radius! + second.radius!;

    // Place the third circle.
    var other = circles[2];
    _place(second, first, other);

    // Initialize the front-chain using the first three circles a, b and c.
    var a = new Chain(node: first);
    var b = new Chain(node: second);
    var c = new Chain(node: other);
    a.next = c.previous = b;
    b.next = a.previous = c;
    c.next = b.previous = a;

    // Attempt to place each remaining circle…
    pack:
    for (var i = 3; i < circles.length; ++i) {
      other = circles[i];
      _place(a.node, b.node, other);
      c = new Chain(node: other);

      // Find the closest intersecting circle on the front-chain, if any.
      // “Closeness” is determined by linear distance along the front-chain.
      // “Ahead” or “behind” is likewise determined by linear distance.
      var j = b.next, k = a.previous, sj = b.node.radius, sk = a.node.radius;
      do {
        if ((sj as num) <= (sk as num)) {
          if (_intersects(j!.node, c.node)) {
            b = j;
            a.next = b;
            b.previous = a;
            --i;
            continue pack;
          }
          sj = sj! + j.node.radius!;
          j = j.next;
        } else {
          if (_intersects(k!.node, c.node)) {
            a = k;
            a.next = b;
            b.previous = a;
            --i;
            continue pack;
          }
          sk = sk! + k.node.radius!;
          k = k.previous;
        }
      } while (j != k!.next);

      // Success! Insert the new circle c between a and b.
      c.previous = a;
      c.next = b;
      a.next = b.previous = b = c;

      // Compute the new closest circle pair to the centroid.
      var aa = _score(a);
      while ((c = c.next!) != b) {
        var ca = _score(c);
        if (ca < aa) {
          a = c;
          aa = ca;
        }
      }
      b = a.next!;
    }

    // Compute the enclosing circle of the front chain.
    var ra = [b.node];
    c = b;
    while ((c = c.next!) != b) ra.add(c.node);
    var f = _enclose(ra)!;

    // Translate the circles to put the enclosing circle around the origin.
    for (var i = 0; i < circles.length; ++i) {
      var a2 = circles[i];
      a2.x = a2.x! - f.x!;
      a2.y = a2.y! - f.y!;
    }

    return f.radius;
  }

  _place(BubbleNode b, BubbleNode a, BubbleNode c) {
    double dx = b.x! - a.x!;
    double dy = b.y! - a.y!;
    double d2 = dx * dx + dy * dy;
    if (d2 != 0) {
      var a2 = a.radius! + c.radius!;
      a2 *= a2;
      var b2 = b.radius! + c.radius!;
      b2 *= b2;
      if (a2 > b2) {
        var x = (d2 + b2 - a2) / (2 * d2);
        var y = sqrt(max(0, b2 / d2 - x * x));
        c.x = b.x! - x * dx - y * dy;
        c.y = b.y! - x * dy + y * dx;
      } else {
        var x = (d2 + a2 - b2) / (2 * d2);
        var y = sqrt(max(0, a2 / d2 - x * x));
        c.x = a.x! + x * dx - y * dy;
        c.y = a.y! + x * dy + y * dx;
      }
    } else {
      c.x = a.x! + c.radius!;
      c.y = a.y;
    }
  }

  _intersects(BubbleNode a, BubbleNode b) {
    var dr = a.radius! + b.radius! - 1e-6;
    var dx = b.x! - a.x!, dy = b.y! - a.y!;
    return dr > 0 && dr * dr > dx * dx + dy * dy;
  }

  _score(Chain<BubbleNode> chain) {
    final height = size.height;
    final width = size.width;

    var a = chain.node,
        b = chain.next!.node,
        ab = a.radius! + b.radius!,
        dx = (a.x! * b.radius! + b.x! * a.radius!) / ab,
        dy = (a.y! * b.radius! + b.y! * a.radius!) / ab;
    return max(dx.abs() * height, dy.abs() * width);
  }

  BubbleNodeBase? _enclose(List<BubbleNodeBase> children) {
    var circles = <BubbleNodeBase>[]
      ..addAll(children)
      ..shuffle();

    BubbleNodeBase? e;
    var dB = <BubbleNodeBase>[];
    var i = 0;
    while (i < circles.length) {
      var p = circles[i];
      if (e != null && _enclosesWeak(e, p)) {
        ++i;
      } else {
        e = _encloseBasis(dB = _extendBasis(dB, p));
        i = 0;
      }
    }

    return e;
  }

  bool _enclosesWeak(BubbleNodeBase a, BubbleNodeBase b) {
    var dr = a.radius! - b.radius! + 1e-6;
    var dx = b.x! - a.x!;
    var dy = b.y! - a.y!;
    return dr > 0 && dr * dr > dx * dx + dy * dy;
  }

  bool _enclosesWeakAll(BubbleNodeBase a, List<BubbleNodeBase> dB) {
    for (var i = 0; i < dB.length; ++i) {
      if (!_enclosesWeak(a, dB[i])) {
        return false;
      }
    }
    return true;
  }

  bool _enclosesNot(BubbleNodeBase a, BubbleNodeBase b) {
    var dr = a.radius! - b.radius!;
    var dx = b.x! - a.x!;
    var dy = b.y! - a.y!;
    return dr < 0 || dr * dr < dx * dx + dy * dy;
  }

  BubbleNodeBase? _encloseBasis(List<BubbleNodeBase> b) {
    switch (b.length) {
      case 1:
        return _encloseBasis1(b[0]);
      case 2:
        return _encloseBasis2(b[0], b[1]);
      case 3:
        return _encloseBasis3(b[0], b[1], b[2]);
    }
    return null;
  }

  BubbleNodeBase _encloseBasis1(BubbleNodeBase a) {
    return BubbleNodeBase(x: a.x, y: a.y, radius: a.radius);
  }

  BubbleNodeBase _encloseBasis2(BubbleNodeBase a, BubbleNodeBase b) {
    var x1 = a.x!;
    var y1 = a.y!;
    var r1 = a.radius!;
    var x2 = b.x!;
    var y2 = b.y!;
    var r2 = b.radius!;
    var x21 = x2 - x1;
    var y21 = y2 - y1;
    var r21 = r2 - r1;
    var l = sqrt(x21 * x21 + y21 * y21);
    return BubbleNodeBase(
        x: (x1 + x2 + x21 / l * r21) / 2,
        y: (y1 + y2 + y21 / l * r21) / 2,
        radius: (l + r1 + r2) / 2);
  }

  BubbleNodeBase _encloseBasis3(
      BubbleNodeBase a, BubbleNodeBase b, BubbleNodeBase c) {
    var x1 = a.x!;
    var y1 = a.y!;
    var r1 = a.radius!;
    var x2 = b.x!;
    var y2 = b.y!;
    var r2 = b.radius!;
    var x3 = c.x!;
    var y3 = c.y!;
    var r3 = c.radius!;
    var a2 = x1 - x2;
    var a3 = x1 - x3;
    var b2 = y1 - y2;
    var b3 = y1 - y3;
    var c2 = r2 - r1;
    var c3 = r3 - r1;
    var d1 = x1 * x1 + y1 * y1 - r1 * r1;
    var d2 = d1 - x2 * x2 - y2 * y2 + r2 * r2;
    var d3 = d1 - x3 * x3 - y3 * y3 + r3 * r3;
    var ab = a3 * b2 - a2 * b3;
    var xa = (b2 * d3 - b3 * d2) / (ab * 2) - x1;
    var xb = (b3 * c2 - b2 * c3) / ab;
    var ya = (a3 * d2 - a2 * d3) / (ab * 2) - y1;
    var yb = (a2 * c3 - a3 * c2) / ab;
    var dA = xb * xb + yb * yb - 1;
    var dB = 2 * (r1 + xa * xb + ya * yb);
    var dC = xa * xa + ya * ya - r1 * r1;
    var r =
        -(dA != 0 ? (dB + sqrt(dB * dB - 4 * dA * dC)) / (2 * dA) : dC / dB);
    return BubbleNodeBase(x: x1 + xa + xb * r, y: y1 + ya + yb * r, radius: r);
  }

  List<BubbleNodeBase> _extendBasis(List<BubbleNodeBase> dB, p) {
    if (_enclosesWeakAll(p, dB)) return [p];

    // If we get here then B must have at least one element.
    for (var i = 0; i < dB.length; ++i) {
      if (_enclosesNot(p, dB[i]) &&
          _enclosesWeakAll(_encloseBasis2(dB[i], p), dB)) {
        return [dB[i], p];
      }
    }

    // If we get here then B must have at least two elements.
    for (var i = 0; i < dB.length - 1; ++i) {
      for (var j = i + 1; j < dB.length; ++j) {
        if (_enclosesNot(_encloseBasis2(dB[i], dB[j]), p) &&
            _enclosesNot(_encloseBasis2(dB[i], p), dB[j]) &&
            _enclosesNot(_encloseBasis2(dB[j], p), dB[i]) &&
            _enclosesWeakAll(_encloseBasis3(dB[i], dB[j], p), dB)) {
          return [dB[i], dB[j], p];
        }
      }
    }

    // If we get here then something is very wrong.
    throw new Error();
  }
}

class Chain<T> {
  final T node;
  Chain<T>? next;
  Chain<T>? previous;

  Chain({required this.node, this.next, this.previous});
}
