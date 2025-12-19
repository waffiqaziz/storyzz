// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_address.dart';

part 'geocoding_response.freezed.dart';
part 'geocoding_response.g.dart';

@freezed
abstract class GeocodingResponse with _$GeocodingResponse {
  const factory GeocodingResponse({
    @JsonKey(name: 'place_id') required int placeId,
    required String licence,
    @JsonKey(name: 'osm_type') required String osmType,
    @JsonKey(name: 'osm_id') required int osmId,
    required String lat,
    required String lon,
    @JsonKey(name: 'display_name') required String displayName,
    required GeocodingAddress address,
    required List<String> boundingbox,
  }) = _GeocodingResponse;

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
      _$GeocodingResponseFromJson(json);
}
