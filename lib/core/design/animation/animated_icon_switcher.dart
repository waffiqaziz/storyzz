import 'package:flutter/material.dart';

/// Animates icon changes with a scale and fade transition.
///
/// The animation is triggered when [valueKey] changes, allowing
/// smooth visual updates between different icons.
class AnimatedIconSwitcher extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Duration duration;
  final Object valueKey;

  const AnimatedIconSwitcher({
    super.key,
    required this.icon,
    required this.valueKey,
    this.size,
    this.color,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Icon(icon, key: ValueKey(valueKey), size: size, color: color),
    );
  }
}
