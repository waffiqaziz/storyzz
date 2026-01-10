import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';

/// A widget that allows users to select a language.
///
/// Displays either a compact icon button (that opens a dialog)
/// or a full dropdown menu, based on [isCompact].
///
/// Parameters:
/// - [onChanged] is called when a new language is selected.
/// - [currentLanguageCode] indicates the currently selected language.
/// - [isCompact] toggles between dialog and dropdown presentation.
class LanguageSelector extends StatelessWidget {
  final String currentLanguageCode;
  final bool isCompact;

  const LanguageSelector({
    super.key,
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

  // dialog
  Widget _buildCompactSelector(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return IconButton(
      icon: const Icon(Icons.language_rounded),
      tooltip: localizations.language,
      onPressed: () {
        context.read<AppProvider>().openLanguageDialog();
      },
    );
  }

  // button drop down
  Widget _buildFullSelector(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final settingsProvider = context.read<SettingsProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isDense: true,
        isExpanded: true,
        items: [
          DropdownMenuItem<String>(
            value: 'en',
            child: Row(
              mainAxisSize: .min,
              children: [
                Image.asset("assets/flag/flag_us.webp", width: 30, height: 25),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    localizations.english,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontWeight: .bold),
                    overflow: .ellipsis,
                  ),
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
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    localizations.indonesian,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontWeight: .bold),
                    overflow: .ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
        value: currentLanguageCode,
        onChanged: (value) {
          if (value != null) {
            settingsProvider.setLocale(value);
          }
        },
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: 150,
          padding: const .only(left: 16, right: 8),
          decoration: BoxDecoration(
            borderRadius: .circular(25),
            color: colorScheme.primaryContainer,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.arrow_drop_down),
          iconEnabledColor: colorScheme.onPrimaryContainer,
          iconDisabledColor: colorScheme.onSurfaceVariant,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: .circular(14),
            color: colorScheme.primaryContainer,
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const .circular(40),
            thickness: .all(6),
            thumbVisibility: .all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: .only(left: 10, right: 10),
        ),
      ),
    );
  }
}
