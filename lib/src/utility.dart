import 'package:animated_slide_switcher/src/spring_curve.dart';
import 'package:flutter/widgets.dart';

/// Extension methods for the [Tween] class that provide convenient chaining
/// with pre configured easing curves.
extension TweenEx<T> on Tween<T> {
  /// Chains this [Tween] with a [CurveTween] using the `Curves.easeOut` curve.
  ///
  /// ### Example:
  /// ```dart
  /// final animation = Tween(begin: 0.0, end: 1.0).chainEasyOut.animate(controller);
  /// ```
  Animatable<T> get chainEasyOut => chain(CurveTween(curve: Curves.easeOut));

  /// Chains this [Tween] with a [CurveTween] using a custom spring-based curve.
  ///
  /// ### Example:
  /// ```dart
  /// final animation = Tween(begin: 0.0, end: 1.0).chainSpring.animate(controller);
  /// ```
  Animatable<T> get chainSpring => chain(CurveTween(curve: SpringCurve()));
}
