import 'package:amazing_icons/outlined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/design/widgets/language_selector.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/settings/presentation/widgets/section_header.dart';
import 'package:storyzz/features/settings/presentation/widgets/settings_card.dart';
import 'package:storyzz/features/settings/presentation/widgets/settings_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Uri _uriRepository = Uri.parse('https://github.com/waffiqaziz/storyzz');
  final Uri _uriFlutter = Uri.parse('https://flutter.dev');

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // appearance
                SectionHeader(
                  title: localizations.appearance,
                  icon: Icons.palette_outlined,
                ),
                const SizedBox(height: 12),
                SettingsCard(
                  child: Column(
                    children: [
                      // dark theme toggle
                      SettingsTile(
                        icon: Icon(Icons.dark_mode_rounded),
                        title: localizations.dark_theme,
                        trailing: Switch(
                          value: provider.setting?.isDark ?? false,
                          onChanged: (bool value) {
                            provider.setTheme(value);
                          },
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),

                      // Language selector
                      SettingsTile(
                        icon: Icon(AmazingIconOutlined.global),
                        title: localizations.language,
                        trailing: LanguageSelector(
                          currentLanguageCode: provider.locale.languageCode,
                          isCompact: false,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ACCOUNT SECTION
                SectionHeader(
                  title: localizations.account,
                  icon: AmazingIconOutlined.user,
                ),
                const SizedBox(height: 12),
                SettingsCard(
                  child: SettingsTile(
                    icon: Icon(AmazingIconOutlined.logout1),
                    title: localizations.logout,
                    subtitle: localizations.logout_description,
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => context.read<AppProvider>().openDialogLogOut(),
                  ),
                ),
                const SizedBox(height: 32),

                // about
                SectionHeader(
                  title: localizations.about,
                  icon: AmazingIconOutlined.infoCircle,
                ),
                const SizedBox(height: 12),
                SettingsCard(
                  child: Column(
                    children: [
                      // source code link
                      SettingsTile(
                        icon: Icon(Icons.code_rounded),
                        title: localizations.view_source_code,
                        subtitle: localizations.view_on_github,
                        trailing: Icon(
                          Icons.open_in_new_rounded,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onTap: () => _launchUrl(_uriRepository),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),

                      // built with Flutter
                      SettingsTile(
                        icon: SizedBox(
                          width: 24,
                          height: 24,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/flutter.svg',
                              width: 20,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                colorScheme.onSurfaceVariant,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        title: localizations.build_with_flutter,
                        subtitle: localizations.learn_flutter,
                        trailing: Icon(
                          Icons.open_in_new_rounded,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onTap: () => _launchUrl(_uriFlutter),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // app version
                Center(
                  child: Text(
                    'Version 0.1.0',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
