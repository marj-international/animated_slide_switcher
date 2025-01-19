import 'package:animated_slide_switcher/animated_slide_switcher.dart';
import 'package:example/common/expansions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterDisplay extends HookWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final count = useState(0);
    return Center(
      child: Column(
        spacing: 20,
        children: [
          RepaintBoundary(
            child: AnimatedSlideSwitcher<int>(
              value: count.value,
              builder: (context, v) => Center(
                child: Text(
                  v.toString(),
                  style: context.text.displayLarge,
                ),
              ),
              predicateDirection: (oldValue, newValue) {
                // bool incremented = newValue == (oldValue ?? 0) + 1;
                // if (newValue == 0 && oldValue == 9) incremented = true;
                // if (newValue == 1 && oldValue == 9) incremented = true;

                return (oldValue ?? 0) < newValue
                    ? AnimationDirection.upToDown
                    : AnimationDirection.downToUp;
              },
            ),
          ),
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton.tinted(
                onPressed: () => count.value = count.value + 1,
                child: Icon(Icons.add),
              ),
              CupertinoButton.tinted(
                onPressed: () => count.value = count.value - 1,
                child: Icon(Icons.remove),
              ),
            ],
          )
        ],
      ),
    );
  }
}
