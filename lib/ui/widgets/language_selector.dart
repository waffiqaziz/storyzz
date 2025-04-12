import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  final Function(String) onChanged;
  final String currentLanguageCode;
  final bool isCompact;

  const LanguageSelector({
    super.key,
    required this.onChanged,
    required this.currentLanguageCode,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return isCompact
        ? _buildCompactSelector(context, localizations)
        : _buildFullSelector(context, localizations);
  }

  Widget _buildCompactSelector(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: localizations.language,
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(localizations.language),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLanguageOption(
                      context,
                      'en',
                      Image.asset(
                        "assets/flag/flag_us.webp",
                        width: 30,
                        height: 25,
                      ),
                      localizations.english,
                      localizations,
                    ),
                    _buildLanguageOption(
                      context,
                      'id',
                      Image.asset(
                        "assets/flag/flag_id.webp",
                        width: 30,
                        height: 25,
                      ),
                      localizations.indonesian,
                      localizations,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(localizations.cancel),
                  ),
                ],
              ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String code,
    Image flag,
    String name,
    AppLocalizations localizations,
  ) {
    final isSelected = currentLanguageCode == code;

    return ListTile(
      leading: flag,
      title: Text(name),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () {
        onChanged(code);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildFullSelector(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: false,
        items: [
          DropdownMenuItem<String>(
            value: 'en',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/flag/flag_us.webp", width: 30, height: 25),
                const SizedBox(width: 8),
                Text(
                  localizations.english,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'id',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/flag/flag_id.webp", width: 30, height: 25),
                const SizedBox(width: 8),
                Text(
                  localizations.indonesian,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
        value: currentLanguageCode,
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: 150,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          iconEnabledColor: Theme.of(context).colorScheme.onPrimaryContainer,
          iconDisabledColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 10, right: 10),
        ),
      ),
    );
  }
}
