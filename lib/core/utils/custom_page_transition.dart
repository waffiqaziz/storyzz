import 'package:flutter/material.dart';

enum TransitionType { slide, fade, scale, slideUp }

class CustomPageTransition extends Page {
  final Widget child;
  final TransitionType transitionType;

  const CustomPageTransition({
    required this.child,
    required LocalKey key,
    this.transitionType = TransitionType.slide,
  }) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        switch (transitionType) {
          case TransitionType.fade:
            return FadeTransition(
              opacity: animation.drive(
                Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).chain(CurveTween(curve: curve)),
              ),
              child: child,
            );
          case TransitionType.scale:
            return ScaleTransition(
              scale: animation.drive(
                Tween<double>(
                  begin: 0.9,
                  end: 1.0,
                ).chain(CurveTween(curve: curve)),
              ),
              child: child,
            );
          case TransitionType.slideUp:
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: Offset(0.0, 1.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: curve)),
              ),
              child: child,
            );
          case TransitionType.slide:
            return SlideTransition(
              position: animation.drive(
                Tween(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: curve)),
              ),
              child: child,
            );
        }
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}
