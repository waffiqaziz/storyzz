import 'package:flutter/material.dart';

class AnimatedTabSwitcher extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const AnimatedTabSwitcher({
    super.key,
    required this.index,
    required this.children,
  });

  @override
  State<AnimatedTabSwitcher> createState() => _AnimatedTabSwitcherState();
}

class _AnimatedTabSwitcherState extends State<AnimatedTabSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.children.length, (i) {
        final isActive = i == widget.index;

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: isActive ? 1.0 : 0.0,
          child: IgnorePointer(ignoring: !isActive, child: widget.children[i]),
        );
      }),
    );
  }
}
