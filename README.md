# Bubble chart

[![pub package](https://img.shields.io/pub/v/bubble_chart.svg)](https://pub.dartlang.org/packages/bubble_chart)

A simple Dart implementation of bubble chart.

<div style="text-align: center"><table><tr>
  <td style="text-align: center">
  <a href="https://github.com/lpongetti/bubble_chart/blob/master/example.png">
    <img src="https://github.com/lpongetti/bubble_chart/blob/master/example.png" width="200"/></a>
</td>
</tr></table></div>

## Usage

Add bubble_chart to your pubspec:

```yaml
dependencies:
  bubble_chart: any # or the latest version on Pub
```

Add in you project.

```dart
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
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: BubbleChart(
        bubbles: bubbles,
      ),
    );
  }
```

### Run the example

See the `example/` folder for a working example app.