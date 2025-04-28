import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// A screen that displays a 404 error message when url is not found.
/// It includes an animated 404 illustration and a button to navigate back to the home page.
class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: 0,
      end: 15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = theme.colorScheme.secondary;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // animated 404 illustration
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: child,
                  );
                },
                child:
                    isDark
                        ? _build404DarkMode(accentColor)
                        : _build404LightMode(accentColor),
              ),
              const SizedBox(height: 40),

              // Error text
              Text(
                AppLocalizations.of(context)!.pageNotFound,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  AppLocalizations.of(context)!.pageNotFoundDescription,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // button to go home
              ElevatedButton.icon(
                onPressed: () => context.go('/'),
                icon: Icon(
                  color: theme.colorScheme.surfaceContainerLowest,
                  Icons.home,
                ),
                label: Text(AppLocalizations.of(context)!.goToHome),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _build404LightMode(Color accentColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          '404',
          style: TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade200,
          ),
        ),
        Text(
          '404',
          style: TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        Positioned(right: 155, top: 30, child: _buildMagnifyingGlass()),
      ],
    );
  }

  Widget _build404DarkMode(Color accentColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          '404',
          style: TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        Text(
          '404',
          style: TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = accentColor,
          ),
        ),
        Positioned(
          right: 155,
          top: 30,
          child: _buildMagnifyingGlass(isDark: true),
        ),
      ],
    );
  }

  Widget _buildMagnifyingGlass({bool isDark = false}) {
    return Transform.rotate(
      angle: -math.pi / 4,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white : Colors.black,
            width: 6,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Transform.translate(
            offset: const Offset(30, 30),
            child: Container(
              width: 6,
              height: 25,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
