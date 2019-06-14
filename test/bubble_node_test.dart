import 'package:bubble_chart/src/bubble_node.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("bubble node leaves", () {
    final root = BubbleNode.node(
      children: [
        BubbleNode.leaf(
          value: 25,
        ),
        BubbleNode.leaf(
          value: 50,
        )
      ],
    );

    expect(root.leaves.length, 2);
    expect(root.leaves[0].value, 25);
  });
}
