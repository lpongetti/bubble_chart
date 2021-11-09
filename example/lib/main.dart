import 'dart:math';

import 'package:bubble_chart/bubble_chart.dart';
import 'package:flutter/material.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BubbleNode> childNode = [];
  late BubbleNode root;

  @override
  void initState() {
    super.initState();
    _addNewNode();
    root = BubbleNode.node(
      padding: 15,
      children: [
        BubbleNode.node(
          padding: 15,
          children: childNode,
          options: BubbleOptions(color: Colors.black),
        ),
        BubbleNode.node(
          padding: 15,
          children: [
            BubbleNode.leaf(
              value: 5,
              options: BubbleOptions(
                color: () {
                  Random random = Random();
                  return Colors
                      .primaries[random.nextInt(Colors.primaries.length)];
                }(),
              ),
            )
          ],
          options: BubbleOptions(color: Colors.black),
        ),
      ],
    );
    // Timer.periodic(Duration(milliseconds: 500), (_) {
    //   _addNewNode();
    // });
  }

  _addNewNode() {
    setState(() {
      Random random = Random();
      BubbleNode node = BubbleNode.leaf(
        value: max(1, random.nextInt(10)),
        options: BubbleOptions(
          color: () {
            Random random = Random();
            return Colors.primaries[random.nextInt(Colors.primaries.length)];
          }(),
        ),
      );
      node.options?.onTap = () {
        setState(() {
          childNode[childNode.indexOf(node)].value += 1;
        });
      };
      childNode.add(node);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BubbleChartLayout(
          root: root,
          duration: Duration(milliseconds: 500),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: () {
          _addNewNode();
        },
      ),
    );
  }
}
