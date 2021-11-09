# Bubble chart

[![pub package](https://img.shields.io/pub/v/bubble_chart.svg)](https://pub.dartlang.org/packages/bubble_chart) ![travis](https://api.travis-ci.com/lpongetti/bubble_chart.svg?branch=master)

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
  final bubbles = BubbleNode.node(
    padding: 15,
    children: [
      BubbleNode.node(
        padding: 30,
        children: [
          BubbleNode.leaf(
            options: BubbleOptions(
              color: Colors.brown,
            ),
            value: 2583,
          ),
          BubbleNode.leaf(
            options: BubbleOptions(
              color: Colors.brown,
            ),
            value: 4159,
          ),
          BubbleNode.leaf(
            options: BubbleOptions(
              color: Colors.brown,
            ),
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: BubbleChartLayout(
        root: bubbles,
      ),
    );
  }
```

### Run the example

See the `example/` folder for a working example app.

## Supporting Me

A donation through my Ko-Fi page would be infinitly appriciated:
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/lorenzopongetti)

but, if you can't or won't, a star on GitHub and a like on pub.dev would also go a long way!

Every donation gives me fuel to continue my open-source projects and lets me know that I'm doing a good job.