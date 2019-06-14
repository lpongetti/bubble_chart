import 'package:bubble_chart/src/bubble_node.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("aaa", () {
    final root = BubbleNode.node(
      children: [
        BubbleNode.leaf(
          value: 4319,
        ),
        BubbleNode.leaf(
          value: 4159,
        ),
        BubbleNode.leaf(
          value: 2583,
        ),
        BubbleNode.leaf(
          value: 2074,
        ),
      ],
    );

    expect(root.leaves.length, 4);
    expect(root.leaves[0].radius, 4319);
  });
}
