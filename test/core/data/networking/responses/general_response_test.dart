// filepath: d:\pem\Dart\Flutter\intermediate\submission\storyzz\test\core\data\networking\responses\general_responses_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/networking/models/general/general_response.dart';

void main() {
  group('GeneralResponse', () {
    test('fromJson should correctly parse JSON', () {
      final json = {'error': true, 'message': 'This is an error message'};

      final generalResponse = GeneralResponse.fromJson(json);

      expect(generalResponse.error, true);
      expect(generalResponse.message, 'This is an error message');
    });

    test('toJson should correctly convert to JSON', () {
      const generalResponse = GeneralResponse(
        error: false,
        message: 'Success!',
      );

      final json = generalResponse.toJson();

      expect(json['error'], false);
      expect(json['message'], 'Success!');
    });

    test('GeneralResponse should be able to be created', () {
      const generalResponse = GeneralResponse(
        error: false,
        message: 'Success!',
      );
      expect(generalResponse.error, false);
      expect(generalResponse.message, 'Success!');
    });
  });
}
