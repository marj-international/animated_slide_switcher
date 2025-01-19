import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A custom spring-based animation curve.
class SpringCurve extends Curve {
  /// Creates a [SpringCurve] with the given [damping], [mass], and [stiffness].
  ///
  /// Defaults are provided for common use cases:
  /// - [damping] controls how quickly the spring comes to rest (higher values settle faster).
  /// - [mass] represents the mass of the spring object.
  /// - [stiffness] controls the spring's tension (higher values oscillate faster).
  SpringCurve({
    double damping = 12.0,
    double mass = 1.0,
    double stiffness = 170.0,
  }) {
    final spring =
        SpringDescription(damping: damping, mass: mass, stiffness: stiffness);
    _simulation = SpringSimulation(spring, 0, 1, 0);
    _finalPosition = 1.0 - _simulation.x(1);
  }

  /// Simulates the spring's physics.
  late final SpringSimulation _simulation;

  /// Precomputed final position for performance optimization.
  late final double _finalPosition;

  @override
  double transform(double t) {
    // Linearly interpolate between the input `t` and the spring's simulated position.
    return t * _finalPosition + _simulation.x(t);
  }
}
