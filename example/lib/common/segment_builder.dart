import 'package:flutter/material.dart';

class SegmentBuilder extends StatelessWidget {
  final int value;
  final Widget Function(int value) builder;

  const SegmentBuilder({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: ValueNotifier<int>(value),
      builder: (context, val, _) => builder(val),
    );
  }
}
