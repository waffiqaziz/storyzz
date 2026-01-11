import 'package:flutter/material.dart';

class AuthScreenWrapper extends StatelessWidget {
  final Widget child;

  const AuthScreenWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Center(
                child: Padding(
                  padding: const .all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
