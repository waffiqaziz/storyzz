import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/provider/address_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section.dart';
import 'package:storyzz/features/detail/presentation/widgets/story_location_map.dart';

/// A section widget that displays the story's address and map location.
///
/// - Shows the formatted address via [AddressSection].
/// - Displays the story location using [StoryLocationMap].
/// - Fetches address asynchronously if not yet requested.
///
/// Parameters:
/// [story] provides the coordinates and ID for the location.
/// [mapControlsEnabled] toggles map interaction UI.
/// [mapKeyPrefix] is used to generate a unique [ValueKey] for the map.
class LocationSection extends StatefulWidget {
  final ListStory story;
  final bool mapControlsEnabled;
  final String mapKeyPrefix;

  const LocationSection({
    super.key,
    this.mapControlsEnabled = true,
    this.mapKeyPrefix = 'detail',
    required this.story,
  });

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  bool _requestedAddress = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // get formatter address
    if (!_requestedAddress) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AddressProvider>().getAddressFromCoordinates(
          widget.story.lat!,
          widget.story.lon!,
        );
      });
      _requestedAddress = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),

        // address
        AddressSection(
          latitude: widget.story.lat!,
          longitude: widget.story.lon!,
          storyId: widget.story.id,
        ),

        const SizedBox(height: 16),

        // map
        StoryLocationMap(
          key: ValueKey(
            '${widget.mapKeyPrefix}-location-map-${widget.story.id}',
          ),
          latitude: widget.story.lat!,
          longitude: widget.story.lon!,
          height: 400.0,
          controlsEnabled: widget.mapControlsEnabled,
          title: widget.story.name,
          location: context.watch<AddressProvider>().state.getAddressOrFallback(
            context,
          ),
        ),
      ],
    );
  }
}
