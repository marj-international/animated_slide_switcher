import 'package:flutter/material.dart';

extension DurationEx on int {
  Duration get ms => Duration(milliseconds: this);
  Duration get sec => Duration(seconds: this);
  Duration get min => Duration(minutes: this);
  Duration get hr => Duration(hours: this);
}

extension NumEx on num {
  List<int> split() => toString().split('').map((e) => int.parse(e)).toList();
  String towDigit() => toString().padLeft(2, '0');
}

extension StringEx on String {
  int get parseInt => int.parse(this);
}

extension DateEx on DateTime {
  int get hour12 => hour % 12 == 0 ? 12 : hour % 12;
  DayPeriod get dayPeriod => hour < 12 ? DayPeriod.am : DayPeriod.pm;
}

extension ContextEx on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get text => theme.textTheme;

  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;
  double get height => size.height;
}
