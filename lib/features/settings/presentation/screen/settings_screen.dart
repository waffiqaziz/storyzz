import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/settings_provider.dart';
import 'package:storyzz/core/widgets/language_selector.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const SettingsScreen({super.key, required this.onLogout});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Uri _url = Uri.parse('https://github.com/waffiqaziz/storyzz');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.settings,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // dark theme toggle
                SwitchListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  secondary: const Icon(Icons.dark_mode_rounded),
                  title: Text(
                    localizations.dark_theme,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  value: provider.setting?.isDark ?? false,
                  onChanged: (bool value) {
                    provider.setTheme(value);
                  },
                ),
                const SizedBox(width: 24),

                // language selector
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  leading: const Icon(Icons.language),
                  title: Text(
                    AppLocalizations.of(context)!.language,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: LanguageSelector(
                    currentLanguageCode: provider.locale.languageCode,
                    onChanged: (code) => provider.setLocale(code),
                    isCompact: false, // dropdown
                  ),
                ),
                const SizedBox(width: 24),

                // github repository link
                InkWell(
                  onTap: _launchUrl,
                  onHover: (value) {},
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.code, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Text(
                          localizations.view_source_code,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
