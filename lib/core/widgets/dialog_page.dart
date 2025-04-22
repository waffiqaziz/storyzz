import 'package:flutter/material.dart';

/// A [Page] that displays a modal dialog using [DialogRoute].
///
/// Useful for displaying dialogs via Navigator 2.0 API.
///
/// Parameters:
/// [child] is the content of the dialog.
/// [barrierDismissible] controls whether tapping outside dismisses the dialog.
/// [barrierColor] sets the color behind the dialog.
class DialogPage<T> extends Page<T> {
  final Widget child;
  final bool barrierDismissible;
  final Color barrierColor;

  const DialogPage({
    required this.child,
    this.barrierDismissible = true,
    this.barrierColor = Colors.black54,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      settings: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext context) => child,
    );
  }
}
