// Language: dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/variant/build_configuration.dart';

import '../../tetsutils/mock_package.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    BuildConfig.reset();
  });

  group('BuildConfig - Paid Version', () {
    setUp(() async {
      await configureMockPackageInfo(packageName: 'com.waffiq.storyzz.paid');
      await BuildConfig.initialize();
    });

    test('should be paid version', () {
      expect(BuildConfig.isPaidVersion, isTrue);
      expect(BuildConfig.isFreeVersion, isFalse);
      expect(BuildConfig.appName, 'Storyzz Premium');
      expect(BuildConfig.canAddLocation, isTrue);
    });
  });
}
