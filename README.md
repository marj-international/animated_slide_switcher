# Animated Slide Switcher

`animated_slide_switcher` is a Flutter package that provides customizable animated slide switching with ease. The widget switches its child on value change with slide-up and slide-down animations, and you can customize the animation behavior based on your needs.

## Features

- **Customizable Slide Animations**: Animate from top-to-bottom (`upToDown`) or bottom-to-top (`downToUp`).
- **Value-Based Animations**: The widget animates based on the value passed to it, making it easy to use with any type.
- **Smooth Transition Effects**: Supports customizable durations for both incoming and outgoing animations.
- **Flexible Widget**: Works with any value type, making it a versatile solution for dynamic UI updates.

## Getting started

To use this package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  animated_slide_switcher: ^0.1.0 # Check for the latest version on pub.dev
```

Then, run `flutter pub get` to install the package

### Demonstrations

<img src="https://github.com/marj-international/animated_slide_switcher/blob/main/assets/clock.gif?raw=true" height="500" alt= 'clock'/>
<img src="https://github.com/marj-international/animated_slide_switcher/blob/main/assets/counter.gif?raw=true" height="500" alt = 'counter'/>
<img src="https://github.com/marj-international/animated_slide_switcher/blob/main/assets/counter_slow.gif?raw=true" height="500" alt = 'counter_slow'/>

## Usage

Here’s an example of how to use the `AnimatedSlideSwitcher` widget:

```dart
import 'package:flutter/material.dart';
import 'package:animated_slide_switcher/animated_slide_switcher.dart';

class CounterApp extends StatefulWidget {
  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Animated Slide Switcher')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSlideSwitcher<int>(
              value: _counter,
              builder: (context, value) => Text(
                '$value',
                style: TextStyle(fontSize: 50),
              ),
              direction: AnimationDirection.upToDown,
              incomingDuration: Duration(milliseconds: 500),
              outgoingDuration: Duration(milliseconds: 150),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>setState(() =>_counter++),
              child: Text('Increment'),
            ),
          ],
        ),
    );
  }
}
```

### Parameters

- value: The value that triggers the animation when changed.
- builder: A function that returns the widget to be displayed based on the current value.
- direction: The direction of the slide animation. (upToDown or downToUp).
- incomingDuration: The duration for the incoming animation.
- outgoingDuration: The duration for the outgoing animation.

## Custom Animation Directions

You can also provide a custom direction based on the previous and current values using the `predicateDirection` parameter:

```dart
AnimatedSlideSwitcher<int>(
  value: _counter,
  builder: (context, value) => Text('$value'),
  predicateDirection: (oldValue, newValue) {
    return newValue > oldValue ? AnimationDirection.downToUp : AnimationDirection.upToDown;
  },
)
```

## Contribution

Feel free to contribute by opening issues or submitting pull requests.

## License

This package is open-source and available under the MIT License.
