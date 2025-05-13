import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/variant/build_configuration.dart';

import '../../tetsutils/mock_package.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    BuildConfig.reset();
  });

  group('BuildConfig - Free Version', () {
    setUp(() async {
      await configureMockPackageInfo(packageName: 'com.waffiq.storyzz');
      await BuildConfig.initialize();
    });

    test('should be free version', () {
      expect(BuildConfig.isFreeVersion, isTrue);
      expect(BuildConfig.isPaidVersion, isFalse);
      expect(BuildConfig.appName, 'Storyzz Free');
      expect(BuildConfig.canAddLocation, isFalse);
    });
  });
}
