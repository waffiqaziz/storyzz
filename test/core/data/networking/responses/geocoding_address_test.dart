import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_address.dart';

void main() {
  group('GeocodingAddress', () {
    test('fromJson should correctly parse JSON', () {
      final json = {
        'amenity': 'Test Amenity',
        'road': 'Test Road',
        'village': 'Test Village',
        'city_district': 'Test City District',
        'city': 'Test City',
        'state': 'Test State',
        'ISO3166-2-lvl4': 'Test ISO4',
        'region': 'Test Region',
        'ISO3166-2-lvl3': 'Test ISO3',
        'postcode': '12345',
        'country': 'Test Country',
        'country_code': 'TC',
      };

      final geocodingAddress = GeocodingAddress.fromJson(json);

      expect(geocodingAddress.amenity, 'Test Amenity');
      expect(geocodingAddress.road, 'Test Road');
      expect(geocodingAddress.village, 'Test Village');
      expect(geocodingAddress.cityDistrict, 'Test City District');
      expect(geocodingAddress.city, 'Test City');
      expect(geocodingAddress.state, 'Test State');
      expect(geocodingAddress.isoLvl4, 'Test ISO4');
      expect(geocodingAddress.region, 'Test Region');
      expect(geocodingAddress.isoLvl3, 'Test ISO3');
      expect(geocodingAddress.postcode, '12345');
      expect(geocodingAddress.country, 'Test Country');
      expect(geocodingAddress.countryCode, 'TC');
    });

    test('toJson should correctly convert to JSON', () {
      const geocodingAddress = GeocodingAddress(
        amenity: 'Test Amenity',
        road: 'Test Road',
        village: 'Test Village',
        cityDistrict: 'Test City District',
        city: 'Test City',
        state: 'Test State',
        isoLvl4: 'Test ISO4',
        region: 'Test Region',
        isoLvl3: 'Test ISO3',
        postcode: '12345',
        country: 'Test Country',
        countryCode: 'TC',
      );

      final json = geocodingAddress.toJson();

      expect(json['amenity'], 'Test Amenity');
      expect(json['road'], 'Test Road');
      expect(json['village'], 'Test Village');
      expect(json['city_district'], 'Test City District');
      expect(json['city'], 'Test City');
      expect(json['state'], 'Test State');
      expect(json['ISO3166-2-lvl4'], 'Test ISO4');
      expect(json['region'], 'Test Region');
      expect(json['ISO3166-2-lvl3'], 'Test ISO3');
      expect(json['postcode'], '12345');
      expect(json['country'], 'Test Country');
      expect(json['country_code'], 'TC');
    });

    test('GeocodingAddress should be able to be created with null values', () {
      const geocodingAddress = GeocodingAddress(
        amenity: null,
        road: null,
        village: null,
        cityDistrict: null,
        city: null,
        state: null,
        isoLvl4: null,
        region: null,
        isoLvl3: null,
        postcode: null,
        country: null,
        countryCode: null,
      );
      expect(geocodingAddress.amenity, null);
      expect(geocodingAddress.road, null);
      expect(geocodingAddress.village, null);
      expect(geocodingAddress.cityDistrict, null);
      expect(geocodingAddress.city, null);
      expect(geocodingAddress.state, null);
      expect(geocodingAddress.isoLvl4, null);
      expect(geocodingAddress.region, null);
      expect(geocodingAddress.isoLvl3, null);
      expect(geocodingAddress.postcode, null);
      expect(geocodingAddress.country, null);
      expect(geocodingAddress.countryCode, null);
    });
  });
}
