// filepath: d:\pem\Dart\Flutter\intermediate\submission\storyzz\test\core\data\networking\responses\geocoding_response_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_address.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_response.dart';

void main() {
  group('GeocodingResponse', () {
    test('fromJson should correctly parse JSON', () {
      final json = {
        'place_id': 12345,
        'licence': 'Test Licence',
        'osm_type': 'Test OSM Type',
        'osm_id': 67890,
        'lat': '12.345',
        'lon': '67.890',
        'display_name': 'Test Display Name',
        'address': {'amenity': 'Test Amenity', 'road': 'Test Road'},
        'boundingbox': ['10', '20', '30', '40'],
      };

      final geocodingResponse = GeocodingResponse.fromJson(json);

      expect(geocodingResponse.placeId, 12345);
      expect(geocodingResponse.licence, 'Test Licence');
      expect(geocodingResponse.osmType, 'Test OSM Type');
      expect(geocodingResponse.osmId, 67890);
      expect(geocodingResponse.lat, '12.345');
      expect(geocodingResponse.lon, '67.890');
      expect(geocodingResponse.displayName, 'Test Display Name');
      expect(geocodingResponse.address, isA<GeocodingAddress>());
      expect(geocodingResponse.address.amenity, 'Test Amenity');
    });

    test('address toJson should return correct Map<String, dynamic>', () {
      const geocodingAddress = GeocodingAddress(
        amenity: 'Test Amenity',
        road: 'Test Road',
      );

      final addressJson = geocodingAddress.toJson();

      expect(addressJson, isA<Map<String, dynamic>>());
      expect(addressJson['amenity'], 'Test Amenity');
      expect(addressJson['road'], 'Test Road');
      expect(addressJson['village'], null);
      expect(addressJson['city_district'], null);
      expect(addressJson['city'], null);
      expect(addressJson['state'], null);
      expect(addressJson['ISO3166-2-lvl4'], null);
      expect(addressJson['region'], null);
      expect(addressJson['ISO3166-2-lvl3'], null);
      expect(addressJson['postcode'], null);
      expect(addressJson['country'], null);
      expect(addressJson['country_code'], null);
    });

    test('toJson should return correct Map<String, dynamic>', () {
      const address = GeocodingAddress(
        amenity: 'Test Amenity',
        road: 'Test Road',
      );

      final response = GeocodingResponse(
        placeId: 12345,
        licence: 'Test Licence',
        osmType: 'Test OSM Type',
        osmId: 67890,
        lat: '12.345',
        lon: '67.890',
        displayName: 'Test Display Name',
        address: address,
        boundingbox: ['10', '20', '30', '40'],
      );

      final json = response.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['place_id'], 12345);
      expect(json['licence'], 'Test Licence');
      expect(json['osm_type'], 'Test OSM Type');
      expect(json['osm_id'], 67890);
      expect(json['lat'], '12.345');
      expect(json['lon'], '67.890');
      expect(json['display_name'], 'Test Display Name');
      expect(json['address'], address.toJson());
      expect(json['boundingbox'], ['10', '20', '30', '40']);
    });
  });
}
