import 'package:flutter/material.dart';
import 'package:bubble_chart/bubble_chart.dart';

final bubbles = [
  Bubble(
    color: Colors.blue,
    radius: 40,
    builder: (context) {
      return Text("ciao");
    },
    onTap: () {
      print("tap1");
    },
  ),
  Bubble(
    color: Colors.black87,
    radius: 38,
    builder: (context) {
      return Text("ciao");
    },
    onTap: () {
      print("tap2");
    },
  ),
  Bubble(
    color: Colors.red,
    radius: 20,
    builder: (context) {
      return Text("ciao");
    },
    onTap: () {
      print("tap3");
    },
  ),
  Bubble(
    color: Colors.brown,
    radius: 60,
    builder: (context) {
      return Text("ciao");
    },
    onTap: () {
      print("tap4");
    },
  ),
];

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
      body: BubbleChart(
        bubbles: bubbles,
      ),
    );
  }
}
