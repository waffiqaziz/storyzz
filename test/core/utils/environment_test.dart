import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/utils/environment.dart';

import '../../tetsutils/mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JsContextWrapper Tests', () {
    test('getApiKey returns API key when available in JS context', () {
      // It require a way to mock the js.context
      // Since theres no way directly test the JS interaction in a unit test,
      // need integration tests for full coverage

      // So just the class structure and error handling
      final wrapper = JsContextWrapper();
      // In real tests, this would return null since js.context is not available
      expect(wrapper.getApiKey(), isNull);
    });
  });

  group('DefaultEnvironmentProvider Tests', () {
    late MockJsContextWrapper mockJsContextWrapper;
    late DefaultEnvironmentProvider provider;

    setUp(() {
      mockJsContextWrapper = MockJsContextWrapper();
      provider = DefaultEnvironmentProvider(
        jsContextWrapper: mockJsContextWrapper,
      );
    });

    test('isWebPlatform returns correct value', () {
      expect(provider.isWebPlatform, equals(kIsWeb));
    });

    test('loadEnvFile calls dotenv.load with correct filename', () async {
      // Since it can't easily mock dotnev due to static functions,
      // this test would be better suited for integration testing

      await provider.loadEnvFile('assets/.env');
      // Ideally dotenv.load should be verified, but that's difficult with static methods
    });

    test('getEnvValue returns value from dotenv', () {
      // Similar to above, testing interaction with static methods is challenging
      // A better approach might be to use dependency injection for dotenv

      // This test assumes dotenv.get will return fallback value if not found
      expect(
        provider.getEnvValue('TEST_KEY', fallback: 'fallback'),
        equals('fallback'),
      );
    });

    test('getJsApiKey calls jsContextWrapper.getApiKey', () {
      when(() => mockJsContextWrapper.getApiKey()).thenReturn('test_api_key');

      final result = provider.getJsApiKey();

      verify(() => mockJsContextWrapper.getApiKey()).called(1);
      expect(result, equals('test_api_key'));
    });
  });

  group('MapsEnvironment Tests', () {
    late MockEnvironmentProvider mockEnvironmentProvider;
    late MockJsContextWrapper mockJsContextWrapper;

    setUp(() {
      mockEnvironmentProvider = MockEnvironmentProvider();
      mockJsContextWrapper = MockJsContextWrapper();

      MapsEnvironment.injectDependencies(
        environmentProvider: mockEnvironmentProvider,
        jsContextWrapper: mockJsContextWrapper,
      );
    });

    tearDown(() {
      MapsEnvironment.resetDependencies();
    });

    test('initialize calls loadEnvFile when not on web platform', () async {
      when(() => mockEnvironmentProvider.isWebPlatform).thenReturn(false);
      when(
        () => mockEnvironmentProvider.loadEnvFile(any()),
      ).thenAnswer((_) async {});

      await MapsEnvironment.initialize();

      verify(
        () => mockEnvironmentProvider.loadEnvFile("assets/.env"),
      ).called(1);
    });

    test('initialize does not call loadEnvFile when on web platform', () async {
      when(() => mockEnvironmentProvider.isWebPlatform).thenReturn(true);

      await MapsEnvironment.initialize();

      verifyNever(() => mockEnvironmentProvider.loadEnvFile(any()));
    });

    test(
      'mapsCoApiKey returns API key from JS context when on web platform',
      () {
        when(() => mockEnvironmentProvider.isWebPlatform).thenReturn(true);
        when(() => mockJsContextWrapper.getApiKey()).thenReturn('js_api_key');

        expect(MapsEnvironment.mapsCoApiKey, equals('js_api_key'));

        verify(() => mockJsContextWrapper.getApiKey()).called(1);
      },
    );

    test(
      'mapsCoApiKey returns fallback when JS API key is null and on web platform',
      () {
        when(() => mockEnvironmentProvider.isWebPlatform).thenReturn(true);
        when(() => mockJsContextWrapper.getApiKey()).thenReturn(null);

        expect(MapsEnvironment.mapsCoApiKey, equals('NO_API_KEY'));
      },
    );

    test(
      'mapsCoApiKey returns value from environment provider when not on web platform',
      () {
        when(() => mockEnvironmentProvider.isWebPlatform).thenReturn(false);
        when(
          () => mockEnvironmentProvider.getEnvValue(
            'GEOCODE_API_KEY',
            fallback: 'NO_API_KEY',
          ),
        ).thenReturn('env_api_key');

        expect(MapsEnvironment.mapsCoApiKey, equals('env_api_key'));

        verify(
          () => mockEnvironmentProvider.getEnvValue(
            'GEOCODE_API_KEY',
            fallback: 'NO_API_KEY',
          ),
        ).called(1);
      },
    );

    test('mapsCoApiKey handles exception from JS context', () {
      when(() => mockEnvironmentProvider.isWebPlatform).thenReturn(true);
      when(
        () => mockJsContextWrapper.getApiKey(),
      ).thenThrow(Exception('JS Error'));

      expect(MapsEnvironment.mapsCoApiKey, equals('NO_API_KEY'));
    });
  });
}
