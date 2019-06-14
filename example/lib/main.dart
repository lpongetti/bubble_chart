import 'package:bubble_chart/bubble_chart.dart';
import 'package:flutter/material.dart';

final root = BubbleNode.node(
  padding: 15,
  children: [
    BubbleNode.node(
      padding: 30,
      children: [
        BubbleNode.leaf(
          color: Colors.brown,
          value: 2583,
        ),
        BubbleNode.leaf(
          color: Colors.yellow,
          value: 4159,
        ),
        BubbleNode.leaf(
          color: Colors.yellow,
          value: 4159,
        ),
      ],
    ),
    BubbleNode.leaf(
      value: 4159,
    ),
    BubbleNode.leaf(
      value: 2074,
    ),
    BubbleNode.leaf(
      value: 4319,
    ),
    BubbleNode.leaf(
      value: 2074,
    ),
    BubbleNode.leaf(
      value: 2074,
    ),
    BubbleNode.leaf(
      value: 2074,
    ),
    BubbleNode.leaf(
      value: 2074,
    ),
  ],
);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 600,
        width: 600,
        child: BubbleChart(
          root: root,
        ),
      ),
    );
  }
}
