import 'dart:math';
import 'dart:core';

abstract class HasPoint {
  Point get point;
}

abstract class QuadSpace<T extends HasPoint> {
  int get count;

  void add(T item);
  bool remove(T item);
  void visit(void f(QuadTreeNode<T> node));
}

class QuadTree<T extends HasPoint> implements QuadSpace<T> {
  final List<T> data;
  final Rectangle _rectangle;
  final QuadTreeNode<T> _root;

  int get count => _root.countRecursive;

  QuadTree(this.data, this._rectangle, [minWidth = 20, minHeight = 20])
      : _root = QuadTreeNode(_rectangle, minWidth, minHeight) {
    data.forEach((f) => add(f));
  }

  void add(T item) => _root.add(item);
  bool remove(T item) => _root.remove(item);
  void visit(void f(QuadTreeNode<T> node)) => _root.visit(f);
}

class QuadTreeNode<T extends HasPoint> {
  final Rectangle _rectangle;
  final num _minWidth, _minHeight;
  final List<QuadTreeNode<T>> _nodes;
  final List<T> _items;

  Rectangle get rectangle => _rectangle;
  T get node => _items.length == 1 ? _items[0] : null;
  bool get isLeaf => _nodes.isEmpty;

  int get countRecursive {
    int count = _items.length;
    _nodes.forEach((node) => count += node.countRecursive);
    return count;
  }

  QuadTreeNode(this._rectangle, this._minWidth, this._minHeight)
      : _items = new List<T>(),
        _nodes = new List<QuadTreeNode<T>>();

  void add(T item) {
    try {
      assert(_rectangle.containsPoint(item.point));
    } catch (e) {
      print(e.toString());
    }

    _items.add(item);

    if (_items.length == 1) return;

    num halfWidth = _rectangle.width / 2;
    num halfHeight = _rectangle.height / 2;

    // if we are at the smallest allowed size then add the item to this node
    if ((halfWidth < _minWidth) || (halfHeight < _minHeight)) return;

    final topLeft =
        Rectangle(_rectangle.left, _rectangle.top, halfWidth, halfHeight);
    final topRight = Rectangle(
        _rectangle.left + halfWidth, _rectangle.top, halfWidth, halfHeight);
    final bottomLeft = Rectangle(
        _rectangle.left, _rectangle.top + halfHeight, halfWidth, halfHeight);
    final bottomRight = Rectangle(_rectangle.left + halfWidth,
        _rectangle.top + halfHeight, halfWidth, halfHeight);

    // if more than one item, add subnodes
    _items.forEach((i) {
      Rectangle rectangle;
      if (topLeft.containsPoint(i.point)) rectangle = topLeft;
      if (topRight.containsPoint(i.point)) rectangle = topRight;
      if (bottomLeft.containsPoint(i.point)) rectangle = bottomLeft;
      if (bottomRight.containsPoint(i.point)) rectangle = bottomRight;

      QuadTreeNode<T> currentNode;
      if (_nodes.length > 0 &&
          _nodes.any((node) => node.rectangle == rectangle)) {
        currentNode = _nodes.firstWhere((node) => node.rectangle == rectangle);
      } else {
        currentNode = QuadTreeNode(rectangle, _minWidth, _minHeight);
        _nodes.add(currentNode);
      }

      currentNode.add(i);
    });

    _items.clear();
  }

  void forEach(void f(T item)) => _items.forEach(f);

  // this method does not free up empty subnodes for gc intentionally,
  // we don't want to churn the heap
  bool remove(T item) {
    // check first if this node has the item
    final index = _items.indexOf(item);
    if (index != -1) {
      _items.removeRange(index, 1);
      return true;
    }

    // check each subnode; if it has the item remove it and return
    for (var node in _nodes) {
      if (node.remove(item)) {
        return true;
      }
    }

    // no subnode has the item
    return false;
  }

  void visit(void f(QuadTreeNode<T> node)) {
    f(this);
    _nodes.forEach((node) => node.visit(f));
  }
}
