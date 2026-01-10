import 'package:flutter/material.dart';

class SettingsTile extends StatefulWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  State<SettingsTile> createState() => SettingsTileState();
}

class SettingsTileState extends State<SettingsTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered && widget.onTap != null
                ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: .circular(12),
                ),
                child: widget.icon,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: .w500),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle!,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(fontWeight: .w300),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
