import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/utils/constants.dart';

class VersionDisplay extends StatefulWidget {
  final AppService appService;
  const VersionDisplay({super.key, required this.appService});

  @override
  State<VersionDisplay> createState() => _VersionDisplayState();
}

class _VersionDisplayState extends State<VersionDisplay> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    if (_packageInfo == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;
    final localeTag = Localizations.localeOf(context).toLanguageTag();

    if (widget.appService.getKIsWeb()) {
      final displayText =
          '${localizations.last_update}${DateFormat('MMM dd, yyyy', localeTag).format(DateTime.now())}';
      final tooltipText = '${localizations.version}${_packageInfo!.version}';

      return Center(
        child: Tooltip(
          message: tooltipText,
          child: Text(
            displayText,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          '${localizations.version}${_packageInfo!.version} (${_packageInfo!.buildNumber})',
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
        ),
      );
    }
  }
}
