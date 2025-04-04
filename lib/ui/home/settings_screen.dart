import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/provider/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const SettingsScreen({super.key, required this.onLogout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Settings",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // notification switch for mobile only
              // dark mode switch (shown on all platforms)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.dark_mode_rounded),
                      const SizedBox(width: 8),
                      Text(
                        "Dark Theme",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Switch(
                    value: provider.setting?.isDark ?? false,
                    onChanged: (bool value) {
                      provider.setTheme(value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
