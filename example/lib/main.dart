import 'dart:math';

import 'package:bubble_chart/bubble_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BubbleNode> childNode = [];

  @override
  void initState() {
    super.initState();
    _addNewNode();
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
          node.value += 1;
          // childNode.remove(node);
        });
      };
      childNode.add(node);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BubbleChartLayout(
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
        duration: const Duration(milliseconds: 500),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text("+"),
        onPressed: () {
          _addNewNode();
        },
      ),
    );
  }
}
