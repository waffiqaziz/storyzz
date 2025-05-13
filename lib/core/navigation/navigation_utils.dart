import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

int calculateSelectedIndex(String location) {
  if (location.startsWith('/map')) {
    return 1;
  }
  if (location.startsWith('/upload')) {
    return 2;
  }
  if (location.startsWith('/settings')) {
    return 3;
  }
  return 0;
}

CustomTransitionPage<dynamic> dialogTransition(
  GoRouterState state,
  Widget childWidget,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    fullscreenDialog: true,
    maintainState: true,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: child,
        ),
      );
    },
    child: childWidget,
  );
}
