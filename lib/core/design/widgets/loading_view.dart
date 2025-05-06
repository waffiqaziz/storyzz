import 'package:flutter/material.dart';

/// A simple centered loading indicator.
///
/// Typically used while waiting for asynchronous operations to complete
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
