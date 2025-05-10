import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';

class LanguageDialogScreen extends StatelessWidget {
  const LanguageDialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final settingsProvider = context.watch<SettingsProvider>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AppProvider>().closeLanguageDialog();
          });
        }
      },
      child: AlertDialog(
        title: Text(localizations.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context: context,
              code: 'en',
              flag: Image.asset(
                "assets/flag/flag_us.webp",
                width: 30,
                height: 25,
              ),
              name: localizations.english,
              currentCode: settingsProvider.locale.languageCode,
            ),
            _buildLanguageOption(
              context: context,
              code: 'id',
              flag: Image.asset(
                "assets/flag/flag_id.webp",
                width: 30,
                height: 25,
              ),
              name: localizations.indonesian,
              currentCode: settingsProvider.locale.languageCode,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<AppProvider>().closeLanguageDialog(),
            child: Text(localizations.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String code,
    required Image flag,
    required String name,
    required String currentCode,
  }) {
    final settingsProvider = context.watch<SettingsProvider>();
    final isSelected = currentCode == code;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      leading: flag,
      title: Text(name),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: () {
        settingsProvider.setLocale(code);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<AppProvider>().closeLanguageDialog();
        });
      },
    );
  }
}
