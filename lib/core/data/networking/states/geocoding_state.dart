import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

part 'geocoding_state.freezed.dart';

@freezed
class GeocodingState with _$GeocodingState {
  const factory GeocodingState.initial() = GeocodingStateInitial;
  const factory GeocodingState.loading() = GeocodingStateLoading;
  const factory GeocodingState.loaded({
    required String formattedAddress,
    required Placemark placemark,
  }) = GeocodingStateLoaded;
  const factory GeocodingState.error(String message) = GeocodingStateError;
}

extension GeocodingStateX on GeocodingState {
  String getAddressOrFallback(
    BuildContext context, {
    AppLocalizations? localizations,
  }) {
    final l10n = localizations ?? AppLocalizations.of(context)!;
    return when(
      initial: () => l10n.address_not_available,
      loading: () => l10n.loading_address,
      loaded: (address, _) => address,
      error: (_) => l10n.address_not_available,
    );
  }

  bool get isLoading => this is GeocodingStateLoading;
  bool get hasError => this is GeocodingStateError;
  bool get hasAddress => this is GeocodingStateLoaded;
}
