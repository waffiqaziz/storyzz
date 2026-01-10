import 'package:amazing_icons/filled.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/design/widgets/square_icon_button.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/map/presentations/providers/map_provider.dart';

class ButtonMapAction extends StatelessWidget {
  const ButtonMapAction({super.key});

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.read<MapProvider>();
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        if (context.watch<AppProvider>().selectedStory == null) ...[
          SquareIconAction(
            icon: AmazingIconFilled.refreshRightSquare,
            onPressed: mapProvider.refreshStories,
            tooltip: localizations.refresh,
          ),
          const SizedBox(width: 8),
          SquareIconAction(
            icon: AmazingIconFilled.layer,
            onPressed: mapProvider.toggleMapType,
            tooltip: localizations.change_map_type,
          ),
        ],
      ],
    );
  }
}
