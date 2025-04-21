import 'package:flutter/material.dart';

/// A custom [Page] that provides a slide-and-fade transition between 
/// authentication screens (e.g., login and register).
///
/// The [isForward] flag controls the slide direction:
/// - `true`: slide from right to left (login → register)
/// - `false`: slide from left to right (register → login)
///
/// Applies smooth animations with different durations for forward and reverse transitions.
class AuthScreenTransition extends Page {
  final Widget child;
  final bool isForward; // true for login->register, false for register->login

  const AuthScreenTransition({
    required this.child,
    required this.isForward,
    required LocalKey key,
  }) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        final begin = isForward 
            ? const Offset(1.0, 0.0)  // Register comes from right
            : const Offset(-1.0, 0.0); // Login comes from left
        const end = Offset.zero;
        
        // Use a custom curve for more natural animation
        final curve = CurveTween(curve: Curves.easeOutCubic);
        final tween = Tween(begin: begin, end: end).chain(curve);
        final offsetAnimation = animation.drive(tween);

        // Fade animation combined with slide
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
