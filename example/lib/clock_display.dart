import 'dart:async';

import 'package:animated_slide_switcher/animated_slide_switcher.dart';
import 'package:example/common/expansions.dart';
import 'package:example/common/segment_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ClockDisplay extends HookWidget {
  const ClockDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final now = useState(DateTime.now());

    useEffect(
      () {
        final timer = Timer.periodic(1.sec, (_) {
          now.value = DateTime.now();
        });
        return timer.cancel;
      },
      [now],
    );

    final period = now.value.dayPeriod;

    return DefaultTextStyle(
      style: context.text.displayLarge!,
      child: Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentBuilder(
            value: now.value.hour12,
            builder: (value) => Expanded(
              child: ClockSegment(digits: value.towDigit().split('')),
            ),
          ),
          const Text(':'),
          SegmentBuilder(
            value: now.value.minute,
            builder: (value) => Expanded(
              child: ClockSegment(digits: value.towDigit().split('')),
            ),
          ),
          const Text(':'),
          SegmentBuilder(
            value: now.value.second,
            builder: (value) => Expanded(
              child: ClockSegment(digits: value.towDigit().split('')),
            ),
          ),
          Text(
            period.name,
            style: context.text.headlineMedium,
          ),
        ],
      ),
    );
  }
}

class ClockSegment extends StatelessWidget {
  const ClockSegment({
    super.key,
    required this.digits,
  });

  final List<String> digits;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white30,
        ),
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...digits.map(
            (e) => Expanded(
              child: Center(
                child: AnimatedSlideSwitcher<int>(
                  value: e.parseInt,
                  builder: (c, v) => Center(
                    child: Text(v.toString()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
