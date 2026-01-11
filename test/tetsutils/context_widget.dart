import 'package:flutter/material.dart';

class TestContextWidget extends StatelessWidget {
  final void Function(BuildContext context) onBuild;

  const TestContextWidget({super.key, required this.onBuild});

  @override
  Widget build(BuildContext context) {
    onBuild(context);
    return const SizedBox.shrink();
  }
}
