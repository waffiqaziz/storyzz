import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

part 'address_load_state.freezed.dart';

@freezed
class AddressLoadState with _$AddressLoadState {
  const factory AddressLoadState.initial() = AddressLoadStateInitial;
  const factory AddressLoadState.loading() = AddressLoadStateLoading;
  const factory AddressLoadState.loaded(String formattedAddress) =
      AddressLoadStateLoaded;
  const factory AddressLoadState.error(String message) = AddressLoadStateError;
}

extension AddressLoadStateX on AddressLoadState {
  String getAddressOrFallback(
    BuildContext context, {
    AppLocalizations? localizations,
  }) {
    final l10n = localizations ?? AppLocalizations.of(context)!;
    return switch (this) {
      AddressLoadStateLoaded(formattedAddress: final address) => address,
      _ => l10n.address_not_available,
    };
  }
}
