import 'package:flutter/material.dart';

class AuthBottomLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback? onPressed;

  const AuthBottomLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade600),
            overflow: .ellipsis,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const .all(8),
            minimumSize: const Size(50, 30),
            tapTargetSize: .shrinkWrap,
          ),
          child: Text(linkText),
        ),
      ],
    );
  }
}
