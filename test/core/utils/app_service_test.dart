import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/utils/constants.dart';

void main() {
  test('getKIsWeb returns false on non-web platform', () {
    final service = AppService();

    expect(service.getKIsWeb(), isFalse);
  });
}
