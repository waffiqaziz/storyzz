// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'geocoding_address.freezed.dart';
part 'geocoding_address.g.dart';

@freezed
abstract class GeocodingAddress with _$GeocodingAddress {
  const factory GeocodingAddress({
    String? amenity,
    String? road,
    String? village,
    @JsonKey(name: 'city_district') String? cityDistrict,
    String? city,
    String? state,
    @JsonKey(name: 'ISO3166-2-lvl4') String? isoLvl4,
    String? region,
    @JsonKey(name: 'ISO3166-2-lvl3') String? isoLvl3,
    String? postcode,
    String? country,
    @JsonKey(name: 'country_code') String? countryCode,
  }) = _GeocodingAddress;

  factory GeocodingAddress.fromJson(Map<String, dynamic> json) =>
      _$GeocodingAddressFromJson(json);
}
