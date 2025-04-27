import 'package:flutter/material.dart';

/// A widget to shows an error if theres problem 
/// when trying to get the curent location
class LocationErrorDisplay extends StatelessWidget {
  final String errorMessage;

  const LocationErrorDisplay({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          errorMessage,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
