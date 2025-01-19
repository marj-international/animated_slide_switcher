import 'package:animated_slide_switcher/src/utility.dart';
import 'package:flutter/material.dart';

/// A function that determines the animation direction based on the old and new values.
///
/// This is used to dynamically compute the [AnimationDirection] for a
/// transition, based on the previous value [o] and the current value [n].
///
/// ### Parameters:
/// - [o]: The previous value, which can be null if it's the initial animation.
/// - [n]: The new value for which the animation is transitioning.
///
/// ### Returns:
/// An [AnimationDirection] specifying whether the animation should move
/// [AnimationDirection.downToUp] or [AnimationDirection.upToDown].
///
/// ### Example:
/// ```dart
/// AnimationDirectionPredicate<int> predicate = (int? oldValue, int newValue) {
///   return (newValue > (oldValue ?? 0))
///       ? AnimationDirection.downToUp
///       : AnimationDirection.upToDown;
/// };
/// ```
typedef AnimationDirectionPredicate<T> = AnimationDirection Function(T? o, T n);

/// Defines the possible directions for animations.
///
/// Used to specify whether an animation should slide upwards ([upToDown])
/// or downwards ([downToUp]).
enum AnimationDirection {
  /// Animates from top to bottom.
  downToUp,

  /// Animates from bottom to top.
  upToDown,
}

/// A widget that switches its child with a slide and fade animation
/// whenever the provided [value] changes.
///
/// The slide direction can be customized using the [direction] parameter.
/// Alternatively, use [predicateDirection] to dynamically determine the direction
/// based on the current and previous values.
///
/// The animation consists of two parts:
/// - The outgoing animation, where the current child slides out.
/// - The incoming animation, where the new child slides in.
///
/// The duration of these animations can be customized using [incomingDuration]
/// and [outgoingDuration].
///
/// This widget is generic and can accept any type [R] for its [value].
///
/// ### Example:
/// ```dart
/// AnimatedSlideSwitcher<int>(
///   value: counter,
///   builder: (context, value) => Text('$value', style: TextStyle(fontSize: 24)),
///   direction: AnimationDirection.downToUp,
///   incomingDuration: Duration(milliseconds: 300),
///   outgoingDuration: Duration(milliseconds: 200),
/// );
/// ```
class AnimatedSlideSwitcher<R> extends StatefulWidget {
  /// Creates an [AnimatedSlideSwitcher].
  ///
  /// - [value] is the current value used to determine if the child should switch.
  /// - [builder] is a function that builds the child widget based on the current [value].
  /// - [direction] specifies the default direction of the slide animation. Defaults to [AnimationDirection.upToDown].
  /// - [predicateDirection] allows dynamic determination of the animation direction based on the current and previous [value].
  /// - [incomingDuration] specifies how long the incoming animation should last. Defaults to [kIncomingDuration].
  /// - [outgoingDuration] specifies how long the outgoing animation should last. Defaults to [kOutgoingDuration].
  const AnimatedSlideSwitcher({
    required this.value,
    required this.builder,
    super.key,
    this.direction = AnimationDirection.upToDown,
    this.predicateDirection,
    this.incomingDuration = kIncomingDuration,
    this.outgoingDuration = kOutgoingDuration,
  });

  /// The default duration for the incoming animation.
  static const Duration kIncomingDuration = Duration(milliseconds: 500);

  /// The default duration for the outgoing animation.
  static const Duration kOutgoingDuration = Duration(milliseconds: 150);

  /// A function that builds the child widget based on the current [value].
  ///
  /// This function is called whenever [value] changes, and it provides the
  /// new value as input to build the child widget.
  final Widget Function(BuildContext context, R value) builder;

  /// The default direction for the slide animation.
  ///
  /// If [predicateDirection] is not provided, this direction is used for both
  /// the outgoing and incoming animations.
  final AnimationDirection direction;

  /// The duration of the incoming animation.
  ///
  /// This controls how long the new child takes to slide in.
  final Duration incomingDuration;

  /// The duration of the outgoing animation.
  ///
  /// This controls how long the previous child takes to slide out.
  final Duration outgoingDuration;

  /// A predicate function that dynamically determines the direction of the animation.
  ///
  /// If provided, this function is called with the previous and current [value]
  /// to determine the direction of the slide animation.
  /// If null, the [direction] parameter is used.
  final AnimationDirectionPredicate<R>? predicateDirection;

  /// The current value that triggers the switch animation.
  ///
  /// When [value] changes, the widget animates the transition from the
  /// old child to the new child using the provided animations.
  final R value;

  @override
  State<AnimatedSlideSwitcher<R>> createState() =>
      _AnimatedSlideSwitcherState<R>();
}

class _AnimatedSlideSwitcherState<R> extends State<AnimatedSlideSwitcher<R>>
    with SingleTickerProviderStateMixin {
  static final _opacityTween = TweenSequence<double>(
    [
      TweenSequenceItem(tween: ConstantTween(0), weight: 20),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1).chainEasyOut,
        weight: 50,
      ),
    ],
  );

  static final _outOpacityTween = CurveTween(curve: Curves.easeOut);

  late R _newValue = widget.value;
  R? _oldValue;

  @override
  void didUpdateWidget(AnimatedSlideSwitcher<R> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      setState(() {
        _oldValue = oldWidget.value;
        _newValue = widget.value;
      });
    }
  }

  AnimationDirection _effectiveDirection() {
    final value = widget.predicateDirection?.call(_oldValue, _newValue);
    return value ?? widget.direction;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.incomingDuration,
      reverseDuration: widget.outgoingDuration,
      transitionBuilder: (child, animation) {
        final isNew = child.key == ValueKey<R>(_newValue);

        final isUpToDown = _effectiveDirection() == AnimationDirection.upToDown;

        if (isNew) {
          final newOffset = Offset(0, isUpToDown ? -0.5 : 0.5);

          final position = TweenSequence<Offset>(
            [
              TweenSequenceItem(
                tween: ConstantTween(newOffset),
                weight: 20,
              ),
              TweenSequenceItem(
                tween: Tween(begin: newOffset, end: Offset.zero).chainSpring,
                weight: 50,
              ),
            ],
          ).animate(animation);

          final opacity = _opacityTween.animate(animation);

          return FadeTransition(
            opacity: opacity,
            child: SlideTransition(
              position: position,
              child: child,
            ),
          );
        }
        final oldOffset = Offset(0, isUpToDown ? 0.5 : -0.5);
        final oldTween = Tween<Offset>(begin: oldOffset, end: Offset.zero);
        return FadeTransition(
          opacity: _outOpacityTween.animate(animation),
          child: SlideTransition(
            position: oldTween.chainEasyOut.animate(animation),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<R>(_newValue),
        child: widget.builder(context, _newValue),
      ),
      layoutBuilder: (c, p) {
        return Stack(
          children: [...p, if (c != null) c],
        );
      },
    );
  }
}
