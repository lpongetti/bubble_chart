import 'package:bubble_chart/src/bubble_node.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  BubbleNode? bubbleNode;

  setUp(() {
    bubbleNode = BubbleNode.node(
      children: [
        BubbleNode.node(
          children: [
            BubbleNode.leaf(
              value: 25,
            ),
            BubbleNode.leaf(
              value: 50,
            )
          ],
        ),
      ],
    );
  });

  test('bubbleNode children lenght', () {
    expect(bubbleNode!.children!.length, 1);
  });

  test('bubbleNode root depth', () {
    expect(bubbleNode!.depth, 0);
  });

  test('bubbleNode children depth', () {
    expect(bubbleNode!.children![0].depth, 1);
  });

  test('bubbleNode leaves lenght', () {
    expect(bubbleNode!.leaves.length, 3);
  });

  test('bubbleNode leaves depth', () {
    expect(bubbleNode!.leaves[1].depth, 2);
  });

  test('bubbleNode eachBefore', () {
    int i = 0;
    bubbleNode!.eachBefore((node) {
      expect(node.depth, i);
      if (i < 2) {
        i++;
      }
    });
  });

  test('bubbleNode parent', () {
    expect(bubbleNode!.parent, null);
    expect(bubbleNode!.children![0].parent, bubbleNode);
  });

  test('bubbleNode value', () {
    expect(bubbleNode!.value, 75);
    bubbleNode!.children![0].children![0].value += 1;
    expect(bubbleNode!.value, 76);
  });
}
