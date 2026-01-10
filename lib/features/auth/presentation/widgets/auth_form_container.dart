import 'package:flutter/material.dart';

class AuthFormContainer extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final String subtitle;
  final List<Widget> fields;
  final Widget actionButton;
  final Widget? bottomLink;
  final bool isLoading;

  const AuthFormContainer({
    super.key,
    required this.formKey,
    required this.title,
    required this.subtitle,
    required this.fields,
    required this.actionButton,
    this.bottomLink,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo/App Icon
          Image.asset('assets/icons/icon.png', height: 80),
          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Form Fields
          ...fields,

          const SizedBox(height: 24),

          // Action Button
          actionButton,

          // Bottom Link (optional)
          if (bottomLink != null) ...[const SizedBox(height: 24), bottomLink!],
        ],
      ),
    );
  }
}
