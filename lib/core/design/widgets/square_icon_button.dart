import 'package:flutter/material.dart';

class SquareIconAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final double size;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;

  const SquareIconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = 22,
    this.padding = const EdgeInsets.all(10),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: Padding(
          padding: padding,
          child: Icon(
            icon,
            size: size,
            color: Theme.of(context).colorScheme.surfaceTint,
          ),
        ),
      ),
    );

    return Tooltip(message: tooltip, child: button);
  }
}
