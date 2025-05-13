import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/navigation/navigation_utils.dart';

void main() {
  group('calculateSelectedIndex', () {
    test('returns 0 for "/"', () {
      expect(calculateSelectedIndex('/'), 0);
    });

    test('returns 1 for "/map"', () {
      expect(calculateSelectedIndex('/map'), 1);
    });

    test('returns 2 for "/upload"', () {
      expect(calculateSelectedIndex('/upload'), 2);
    });

    test('returns 3 for "/settings"', () {
      expect(calculateSelectedIndex('/settings'), 3);
    });

    test('returns 0 for unknown route', () {
      expect(calculateSelectedIndex('/unknown'), 0);
    });
  });
}
